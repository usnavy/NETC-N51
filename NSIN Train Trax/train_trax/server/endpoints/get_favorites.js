import { Article, Json, User } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'results', 'completed');
	json.set('results', []);
	json.set('completed', []);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();

	// Query database for favorited articles and return
	const articles = await Article.getFavoritesFromUser(user.user_id);
	for (const row of articles) {
		const article = {
			article_id: row.article_id,
			article: row.article,
			start_time: row.start_time,
			complete_time: row.complete_time
		};

		json.get('results').push(article);
		if (row.complete_time !== null) json.get('completed').push(article);
	}
	return json.send();
};
