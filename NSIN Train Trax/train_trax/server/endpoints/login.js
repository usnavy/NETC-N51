import { Constants, Json, User } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { email, password } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'token');

	// Check if one or more fields is not declared
	const undef = [];
	if (email === undefined) undef.push('email');
	if (password === undefined) undef.push('password');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Retrieve user data
	const user = await User.fromLogin(email, password);
	if (user === undefined) return json.badCredentials().send();

	// Create token and update user information, return token
	const token = Constants.generateToken(user.user_id);
	await User.setLoginToken(user.user_id, token);
	json.set('token', token);
	return json.send();
};
