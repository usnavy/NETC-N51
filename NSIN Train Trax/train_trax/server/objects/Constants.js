import md5 from 'md5';

export default class Constants {
	
	// DATABASE CONSTANTS
	static get DB_EMAIL_MAX_LENGTH() {
		return 100;
	}

	static get DB_NAME_MAX_LENGTH() {
		return 100;
	}

	static get DB_PHONE_NUMBER_MAX_LENGTH() {
		return 20;
	}

	static get DB_ARTICLE_MAX_LENGTH() {
		return 1023;
	}

	static get DB_TEAM_NAME_MAX_LENGTH() {
		return 100;
	}

	static get DB_QUESTION_MAX_LENGTH() {
		return 1023;
	}

	static get DB_ANSWER_MAX_LENGTH() {
		return 1023;
	}

	// OTHER CONSTANTS
	static get MAX_ARTICLES() {
		return 5;
	}
	
	// HELPER FUNCTIONS
	static generateToken(user_id) {
		return md5(`token of ${user_id} at time ${new Date().getTime().toString()}`);
	}
}