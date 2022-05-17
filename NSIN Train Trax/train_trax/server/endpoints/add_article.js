import { Article, Constants, Json, User, xApiStatement } from '../objects/Objects.js';
import xApiStatement from '../objects/xApiStatement.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token, article } = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (article === undefined) undef.push('article');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Check if one or more fields are too long
	if (article.length > Constants.DB_ARTICLE_MAX_LENGTH) undef.push('article');
	if (undef.length > 0) return json.badData(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();

	// Add article to DB
	await Article.add(user.user_id, article, new Date().toISOString());
	await new xApiStatement(user, 'added_article').setObject(xApiStatement.OBJECT_ADDED_ARTICLE, 'Added an article to their read list', article).push();
	return json.send();
};
