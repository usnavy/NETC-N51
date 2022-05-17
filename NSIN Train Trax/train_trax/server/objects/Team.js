import DB from './DB.js';

export default class Team {
	
	// Get teams
	static async getTeamsFromUser(user_id) {
		return DB.query('SELECT * FROM teams WHERE team_id in (SELECT team_id FROM team_users WHERE user_id = $1);', [user_id]);
	}

	static async getTeamsFromAdministrator(user_id) {
		return DB.query('SELECT * FROM teams WHERE administrator = $1;', [user_id]);
	}

	// Get Team User
	static async getMemberFromTeamAndId(team_id, user_id) {
		return DB.query('SELECT user_id FROM team_users WHERE team_id = $1 AND user_id = $2;', [team_id, user_id]).then(value => value[0]);
	}

	static async getMembersFromTeam(team_id) {
		return DB.query('SELECT user_id FROM team_users WHERE team_id = $1;', [team_id]);
	}

	static async getUsersFromTeam(team_id) {
		return DB.query('SELECT * FROM users WHERE user_id IN (SELECT user_id FROM team_users WHERE team_id = $1);', [team_id]);
	}

	// Insert and Delete Team User
	static async addMemberToTeam(team_id, user_id) {
		return DB.query('INSERT INTO team_users(team_id, user_id) VALUES($1, $2);', [team_id, user_id]);
	}

	static async removeMemberFromTeam(team_id, user_id) {
		return DB.query('DELETE FROM team_users WHERE team_id = $1 AND user_id = $2;', [team_id, user_id]);
	}
	
	// Insert and Delete Team
	static async getTeam(team_id) {
		return DB.query("SELECT * FROM teams WHERE team_id = $1;", [team_id]).then(value => value[0]);
	}

	static async addTeam(user_id, name) {
		return DB.query('INSERT INTO teams(administrator, team_name) VALUES($1, $2);', [user_id, name]);
	}

	static async removeTeam(team_id) {
		return DB.query('DELETE FROM team_users WHERE team_id = $1;', [team_id])
			.then(value => [value, DB.query('DELETE FROM teams WHERE team_id = $1;', [team_id])]);
    }
}
