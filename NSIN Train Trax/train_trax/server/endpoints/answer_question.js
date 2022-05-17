import { Constants, Json, Question, User, xApiStatement } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token, question_id, answer_text} = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (question_id === undefined) undef.push('question_id');
	if (answer_text === undefined) undef.push('answer_text');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Check if one or more fields are too long
	if (answer_text.length > Constants.DB_ANSWER_MAX_LENGTH) undef.push('answer_text');
	if (undef.length > 0) return json.badData(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
    if (user === undefined) return json.badToken().send();
	if (!user.administrator) return json.notAdmin().send();

	// Retrieve Question data
	const question = await Question.fromId(question_id);
	if (question === undefined) return json.badQuestion().send();

	// Update question information
	await Question.addAnswer(question_id, user.user_id, answer_text);
	await new xApiStatement(user, 'answered_question').setObject(xApiStatement.OBJECT_ANSWERED_QUESTION, 'Answered a question', `Answered '${question.question}' with '${answer_text}'`).push();
	return json.send();
};
