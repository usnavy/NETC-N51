import DB from './DB.js';

export default class Question {
    
	// Insert
    static async addQuestion(user_id, question) {
		return DB.query('INSERT INTO questions(user_id, question) VALUES($1, $2)', [user_id, question]);
    }
    
    static async addAnswer(question_id, user_id, answer) {
		return DB.query('INSERT INTO answers(question_id, user_id, answer) VALUES($1, $2, $3)', [question_id, user_id, answer]);
	}

	// Select
	static async getQuestions() {
		return DB.query('SELECT * FROM questions;');
	}

	static async fromId(question_id) {
		return DB.query('SELECT * FROM questions where question_id = $1;', [question_id]);
	}

	static async getQuestionsFromId(user_id) {
		return DB.query('SELECT * FROM questions where user_id = $1;', [user_id]);
	}

	static async getAnswers() {
		return DB.query('SELECT * FROM answers;');
	}
}
