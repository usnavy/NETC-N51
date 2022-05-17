import { Json, User, xApiStatement } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { validation_token, password } = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (validation_token === undefined) undef.push('validation_token');
	if (password === undefined) undef.push('password');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromToken(validation_token);
	if (user === undefined) return json.badCredentials().send();

	// Update the user's password
	await User.setPassword(user.user_id, password);
	await User.setValidationToken(user.user_id, null, null);
	await new xApiStatement(user, 'reset_password').setObject(xApiStatement.OBJECT_PASSWORD_RESET, 'Reset their password').push();
	return json.send();
};
