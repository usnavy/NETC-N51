import { Constants, Json, Question, User, xApiStatement } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token, question_text } = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (question_text === undefined) undef.push('question_text');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Check if one or more fields are too long
	if (question_text.length > Constants.DB_QUESTION_MAX_LENGTH) undef.push('question_text');
	if (undef.length > 0) return json.badData(undef).send();

	// Retrieve user data
	const user = await User.fromToken(token);
    if (user === undefined) return json.badToken().send();
    
	// Update question information
	await Question.addQuestion(user.user_id, question_text);
	await new xApiStatement(user, 'asked_question').setObject(xApiStatement.OBJECT_ASKED_QUESTION, 'Asked a question', question_text).push();
	return json.send();
};
