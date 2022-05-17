import { Article, Json, User, xApiStatement } from '../objects/Objects.js';

export default (isStart) => async (request, response) => {
	// Destructure request body into relevant variables
	const { token, article_id, time } = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (article_id === undefined) undef.push('article_id');
	if (isStart && time === undefined) undef.push('time');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();
    
    // Retrieve article data
	const article = await Article.getArticleFromId(article_id);
    if (article === undefined || article.user_id !== user.user_id) return json.badArticle().send();

    // Update Article information
    await (isStart ? Article.setStart : Article.setEnd)(article_id, new Date(time ?? new Date()).toISOString());
	if (isStart) await new xApiStatement(user, 'set_article_start_time').setObject(xApiStatement.OBJECT_SET_ARTICLE_START_TIME, 'Set the start time of an article', article.article).push();
	else await new xApiStatement(user, 'set_article_end_time').setObject(xApiStatement.OBJECT_SET_ARTICLE_END_TIME, 'Set the end time of an article', article.article).push();
	return json.send();
};
