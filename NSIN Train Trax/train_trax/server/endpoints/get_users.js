import { Json, Team, User } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { token } = request.body;

	// Create return JSON structure
	const json = new Json(response, 'users');
	json.set('users', [])

	// Check if one or more fields is not declared
	const undef = [];
	if (token === undefined) undef.push('token');
	if (undef.length > 0) return json.badPayload(undef).send();

	const self = await User.fromToken(token);
	if (self === undefined) return json.badToken().send();

	// Retrieve user data
	const users = await User.getUsers();
	for(const user of users) {
		json.get('users').push({
			user_id: user.user_id,
			email: self.administrator ? user.email : '',
			name: user.name,
			phone_number: self.administrator ? user.phone_number : ''
		});
	}

	// Send information
	return json.send();
};
