import DB from './DB.js';
import md5 from 'md5';

export default class User {
	
	// Get User
	static async fromId(user_id) {
		return DB.query('SELECT * FROM users WHERE user_id = $1;', [user_id]).then(value => value[0]);
	}

	static async fromToken(token) {
		return DB.query('SELECT * FROM users WHERE (user_token = $1 AND token_expire_time > $2) OR (validation_token = $1 AND validation_expire_time > $2);', [token, new Date().toISOString()]).then(value => value[0]);
	}

	static async fromLogin(email, password) {
		return DB.query('SELECT * FROM users WHERE email = $1 AND password = $2;', [email, md5(password)]).then(value => value[0]);
	}

	static async fromEmail(email) {
		return DB.query('SELECT * FROM users WHERE email = $1;', [email]).then(value => value[0]);
	}

	// Get all users
	static async getUsers() {
		return DB.query('SELECT * FROM users;');
	}

	// Modify User info
	static async setLoginToken(user_id, token, expire_time = new Date(new Date().getTime() + 60 * 60 * 1000).toISOString()) {
		return DB.query('UPDATE users SET user_token = $1, token_expire_time = $2 WHERE user_id = $3;', [token, expire_time, user_id]);
	}

	static async setValidationToken(user_id, token, expire_time = new Date(new Date().getTime() + 60 * 60 * 1000).toISOString()) {
		return DB.query('UPDATE users SET validation_token = $1, validation_expire_time = $2 WHERE user_id = $3;', [token, expire_time, user_id]);
	}

	static async setPassword(user_id, password) {
		return DB.query('UPDATE users SET password = $1 WHERE user_id = $2;', [md5(password), user_id]);
	}

	// Insert
	static async create(email, password, name, phone_number) {
		return DB.query('INSERT INTO users(email, password, name, phone_number) VALUES($1, $2, $3, $4);', [email, md5(password), name, phone_number]);
	}
}
