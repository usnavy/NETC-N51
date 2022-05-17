import { Article, Json, Team, User } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token , team_id } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'member_articles', 'team_articles', 'team_completed', 'completion_rate');
	json.set('member_articles', []);
	json.set('team_articles', []);
	json.set('team_completed', []);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (team_id === undefined) undef.push('team_id');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();
	if (!user.administrator) return json.notAdmin().send();

    // Get user_ids of all team members
    const users = await Team.getUsersFromTeam(team_id);

    // Filter all articles by start time
    let team_articles = await Article.getArticlesFromUsers(users.map(u => u.user_id));
    team_articles.sort(function(a, b) { return a.start_time - b.start_time;})

    // Get articles for each team member
    for (const u of users) {
        const list = [];
        for (const article of team_articles) {
            if (article.user_id === u.user_id) {
                list.push({
                    'article_id': article.article_id,
                    'article': article.article
                });
            }
            if (list.length === 5) break;
        }
        json.get('member_articles').push({
            'user_id': u.user_id,
			'name': u.name,
            'articles': list
        });        
    }

    // Take top 5 most recently started articles
    for (const item of team_articles.slice(0, 5)) {
        json.get('team_articles').push({
            'article_id': item.article_id,
            'article': item.article
        });
    }

    // Filter all articles by complete time and take the top 5
    // What if they don't have a complete time?
    team_articles.sort(function(a, b) { return a.complete_time - b.complete_time;})
    for (const item of team_articles.slice(0, 5)) {
        if (item.complete_time !== null) {
            json.get('team_completed').push({
                'article_id': item.article_id,
                'article': item.article
            });
        }
    }

    // Count of completed / count of all
    const complete = team_articles.filter(({complete_time}) => complete_time !== null).length;
	json.set('completion_rate', team_articles.length === 0 ? 0 : complete / team_articles.length);
	return json.send();
};
