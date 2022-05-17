import { Article, Json, User } from '../objects/Objects.js';

export default (isDomain) => async (request, response) => {
	// Destructure request body into relevant variables
	const { token } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'results');
	json.set('results', []);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badCredentials().send();

	// Query database for starred articles/domains and return
	const articles = await (isDomain ? Article.getStarredDomains : Article.getStarredArticles)();
	for (const row of articles) json.get('results').push(row.article);
	return json.send();
};
