import { Json, Team, User } from '../objects/Objects.js';
import get_stats from './get_stats.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token, team_id } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'stats');

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (team_id === undefined) undef.push('team_id');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();
	if (!user.administrator) return json.notAdmin().send();

	// Get team info
	const team = await Team.getTeam(team_id);
	if (team === undefined) return json.error(Json.STATUS_BAD_INFO, 'Invalid Team', 'The given team does not exist.').send();
	if (user.user_id !== team.administrator) return json.notAdmin().send();

	// Get stats for user
	json.set('stats', await get_stats(await Team.getUsersFromTeam(team_id), true));

	// Send information
	return json.send();
};
