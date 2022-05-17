import { Constants, Json, Team, User, xApiStatement } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token, team_name } = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (team_name === undefined) undef.push('team_name');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Check if one or more fields are too long
	if (team_name.length > Constants.DB_TEAM_NAME_MAX_LENGTH) undef.push('team_name');
	if (undef.length > 0) return json.badData(undef).send();

	// Retrieve user data
	const admin = await User.fromToken(token);
	if (admin === undefined) return json.badToken().send();
	if (!admin.administrator) return json.notAdmin().send();

	// Create team
	await Team.addTeam(admin.user_id, team_name);
	await new xApiStatement(admin, 'created_team').setObject(xApiStatement.OBJECT_CREATED_TEAM, 'Created a team', team_name).push();
	return json.send();
};
