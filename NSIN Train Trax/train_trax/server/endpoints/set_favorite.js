import { Article, Json, User, xApiStatement } from '../objects/Objects.js';

export default (addFavorite) => async (request, response) => {
	// Destructure request body into relevant variables
	const { token, article_id } = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (article_id === undefined) undef.push('article_id');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badCredentials().send();

	// Retrieve article data
	const article = await Article.getArticleFromId(article_id);
    if (article === undefined || article.user_id !== user.user_id) return json.badArticle().send();

	// Query database for favorited articles and return
	await Article.setFavorite(article_id, addFavorite);
	if (addFavorite) await new xApiStatement(user, 'added_favorite').setObject(xApiStatement.OBJECT_ADDED_FAVORITE, 'Added an article to their favorites list', article.article).push();
	else await new xApiStatement(user, 'removed_favorite').setObject(xApiStatement.OBJECT_REMOVED_FAVORITE, 'Removed an article from their favorites list', article.article).push();
	return json.send();
};
