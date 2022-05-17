export default class Json {

	// Private class variables
	#replied = false;
	#status = Json.STATUS_SUCCESS;
	#response;
	#json = {
		'error': '',
		'message': ''
	};

	// Constructor
	constructor(response, ...parameters) {
		this.#response = response;
		for (const name of parameters) this.#json[name] = '';
	}

	// Generic functions
	message(message) {
		this.#json['message'] = message;
		return this;
	}

	error(status, error, message) {
		this.#status = status;
		this.#json['error'] = error;
		this.#json['message'] = message;
		return this;
	}

	// Object getter and setters
	set(field, value) {
		this.#json[field] = value;
		return this;
	}

	get(field) {
		return this.#json[field];
	}

	// Helper functions
	badPayload(fields) {
		return this.error(Json.STATUS_BAD_PAYLOAD, 'Invalid payload', `Missing the following field${fields.length === 1 ? '' : 's'}: ${fields.join(', ')}.`);
	}

	badData(fields) {
		return this.error(Json.STATUS_BAD_PAYLOAD, 'Invalid payload', `Invalid data for the following field${fields.length === 1 ? '' : 's'}: ${fields.join(', ')}.`);
	}

	badCredentials() {
		return this.error(Json.STATUS_BAD_CREDENTIALS, 'Invalid credentials', 'No user exists with the given email and/or password.');
	}

	badToken() {
		return this.error(Json.STATUS_BAD_CREDENTIALS, 'Invalid credentials', 'The token provided is either invalid or expired.')
	}

	badArticle() {
		return this.error(Json.STATUS_BAD_INFO, 'Unknown article', 'The article with the given ID does not exist.');
	}

	badQuestion() {
		return this.error(Json.STATUS_BAD_INFO, 'Unknown question', 'The question with the given ID does not exist.');
	}

	notAdmin() {
		return this.error(Json.STATUS_BAD_PERMISSION, 'Invalid permission', 'The user does not have permission to access this endpoint.');
	}

	// Send the json as the response
	send() {
		if (!this.#replied) {
			this.#replied = true;
			this.#response.status(this.#status).json(this.#json);
		}

		return this;
	}

	// constant error values
	static get STATUS_SUCCESS() {
		return 200;
	}

	static get STATUS_BAD_PAYLOAD() {
		return 400;
	}

	static get STATUS_BAD_CREDENTIALS() {
		return 401;
	}

	static get STATUS_BAD_INFO() {
		return 401;
	}

	static get STATUS_BAD_PERMISSION() {
		return 403;
	}
}