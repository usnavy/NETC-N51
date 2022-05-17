import { Constants, Json, Mailer, User, xApiStatement } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { email } = request.body;

	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (email === undefined) undef.push('email');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromEmail(email);
	if (user === undefined) return json.badCredentials().send();

	// Create token and update user information
	const token = Constants.generateToken(user.user_id);
	await User.setValidationToken(user.user_id, token);

	// Send email
	await Mailer.sendEmail(user.email, 'Train Trax Password Reset', `Hello, ${user.name}! Please enter the following code into the webpage to reset your password. This code expires in 1 hour.\nCode: ${token}\n\nIf you did not request a password reset or do not wish to change your password, please ignore this email.`);
	await new xApiStatement(user, 'requested_password_reset').setObject(xApiStatement.OBJECT_REQUESTED_PASSWORD_RESET, 'Requested a password reset').push();
	return json.send();
};
