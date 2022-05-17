import { Json, Question, User } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'questions');
	json.set('questions', []);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
	if (user === undefined) return json.badToken().send();

	// Retrieve data
	const questions = await Question.getQuestions();
	const answers = await Question.getAnswers();

	// Build data
	for (const question of questions) {
		// Get question's answers
		const ans = [];
		for (const answer of answers) {
			if (question.question_id === answer.question_id) {
				ans.push(answer.answer);
			}
		}

		// Add object to json
		json.get('questions').push({
			'question_id': question.question_id,
			'question': question.question,
			'answers': ans
		});
	}

	// Send
	return json.send();
};
