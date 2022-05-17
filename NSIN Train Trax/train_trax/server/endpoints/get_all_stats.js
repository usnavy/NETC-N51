import { Json, User } from '../objects/Objects.js';
import get_stats from './get_stats.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'stats');

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();

	// Get stats for user
	json.set('stats', await get_stats(await User.getUsers(), false));

	// Send information
	return json.send();
};
