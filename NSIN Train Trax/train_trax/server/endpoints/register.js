import { Constants, Json, Mailer, User, xApiStatement } from '../objects/Objects.js';

export default async (request, response) => {
	// Destructure request body into relevant variables
	const { email, password, name, phone_number } = request.body;
	
	// Create return JSON structure
	const json = new Json(response);

	// Check if one or more fields is not declared
	const undef = [];
	if (email === undefined) undef.push('email');
	if (password === undefined) undef.push('password');
	if (name === undefined) undef.push('name');
	if (phone_number === undefined) undef.push('phone_number');
	if (undef.length > 0) return json.badPayload(undef).send();

	// Check if one or more fields are too long
	if (email.length > Constants.DB_EMAIL_MAX_LENGTH) undef.push('email');
	if (name.length > Constants.DB_NAME_MAX_LENGTH) undef.push('name');
	if (phone_number.length > Constants.DB_PHONE_NUMBER_MAX_LENGTH) undef.push('phone_number');
	if (undef.length > 0) return json.badData(undef).send();

	// If email exists, return duplicate email
	if (await User.fromEmail(email) !== undefined) return json.error(Json.STATUS_BAD_INFO, 'Duplicate email', 'A user with the given email already exists.').send();

	// If user does not exist, add them and send an email
	await User.create(email, password, name, phone_number);
	await Mailer.sendEmail(email, 'Welcome to Train Trax!', `Welcome ${name} to Train Trax!`);

	const user = await User.fromEmail(email);
	await new xApiStatement(user, 'registered').setObject(xApiStatement.OBJECT_REGISTERED, 'Registered').push();
	return json.send();
};
