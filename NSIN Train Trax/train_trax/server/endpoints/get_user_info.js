import { Json, Team, User } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'user_id', 'email', 'name', 'phone_number', 'administrator', 'teams_admin', 'teams_user');
	json.set('teams_admin', []);
	json.set('teams_user', []);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();

	json.set('user_id', user.user_id);
	json.set('email', user.email);
	json.set('name', user.name);
	json.set('phone_number', user.phone_number);
	json.set('administrator', user.administrator);

	for (const team of await Team.getTeamsFromAdministrator(user.user_id)) {
		const team_users = [];
		for (const team_user of await Team.getUsersFromTeam(team.team_id)) {
			team_users.push({
				user_id: team_user.user_id,
				name: team_user.name
			});
		}

		const admin = await User.fromId(team.administrator);

		json.get('teams_admin').push({
			team_id: team.team_id,
			team_name: team.team_name,
			administrator: {
				user_id: admin.user_id,
				name: admin.name
			},
			users: team_users
		});
	}

	for (const team of await Team.getTeamsFromUser(user.user_id)) {
		const team_users = [];
		for (const team_user of await Team.getUsersFromTeam(team.team_id)) {
			team_users.push({
				user_id: team_user.user_id,
				name: team_user.name
			});
		}

		const admin = await User.fromId(team.administrator);

		json.get('teams_user').push({
			team_id: team.team_id,
			team_name: team.team_name,
			administrator: {
				user_id: admin.user_id,
				name: admin.name
			},
			users: team_users
		});
	}

	// Send information
	return json.send();
};
