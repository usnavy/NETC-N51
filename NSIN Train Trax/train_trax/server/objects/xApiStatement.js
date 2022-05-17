import { User } from './Objects.js';

export default class xApiStatement {

	#actor = null;
	#verb = null;
	#object = null;

	// Constructor
	constructor(actor, verb) {
		if (actor !== undefined) this.setActor(actor);
		if (verb !== undefined) this.setVerb(verb);
	}

	setActor(user) {
		this.#actor = xApiStatement.actor(user);
		return this;
	}

	setVerb(verb) {
		if (verb instanceof String) this.#verb = xApiStatement.verb(verb);
		else this.#verb = verb;
		return this;
	}

	setObject(id, name, description) {
		this.#object = xApiStatement.object(id, name, description);
	}

	async push() {
		// Prevent pushing to xAPI server if it isn't defined
		if (process.env.XAPI_URL === undefined) return;

		// Create statement
		const statement = {
			actor: this.#actor,
			verb: this.#verb,
			object: this.#object
		};

		// POST data to LRS
		await fetch(process.env.XAPI_URL + 'statements', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json',
				'Authorization': process.env.XAPI_AUTH
			},
			body: JSON.stringify(statement)
		}).catch(error => console.log(error));
	}

	// actor
	static actor(user) {
		if (user instanceof Number || user instanceof String) {
			return xApiStatement.actor(User.fromId(user));
		}

		return {
			objectType: 'Agent',
			name: user.name,
			account: {
				homePage: process.env.APP_HOME,
				name: String(user.user_id)
			}
		};
	}

	// verbs
	static get VERB_LAUNCHED() {
		return xApiStatement.verb('launched');
	}
	
	static get VERB_INITIALIZED() {
		return xApiStatement.verb('initialized');
	}

	static get VERB_TERMINATED() {
		return xApiStatement.verb('terminated');
	}

	static get VERB_PASSED() {
		return xApiStatement.verb('passed');
	}

	static get VERB_COMPLETED() {
		return xApiStatement.verb('completed');
	}

	static get VERB_FAILED() {
		return xApiStatement.verb('failed');
	}

	static get VERB_ABANDONED() {
		return xApiStatement.verb('abandoned');
	}

	static get VERB_WAIVED() {
		return xApiStatement.verb('waived');
	}

	static get VERB_SATISFIED() {
		return xApiStatement.verb('satisfied');
	}

	static verb(verb) {
		return {
			id: process.env.XAPI_URL + 'verb/' + verb,
			display: {
				'en-US': verb
			}
		};
	}

	// object
	static object(id, name, description) {
		const obj = {
			objectType: 'Activity',
			id: id,
			definition: {}
		}

		if (name !== undefined) obj.definition.name = name;
		if (description !== undefined) obj.definition.description = description;

		return obj;
	}

	static get OBJECT_ADDED_ARTICLE() {
		return process.env.XAPI_URL + 'added_article/';
	}

	static get OBJECT_ADDED_MEMBER() {
		return process.env.XAPI_URL + 'added_member_to_team/';
	}

	static get OBJECT_STARRED_DOMAIN() {
		return process.env.XAPI_URL + 'starred_domain/';
	}

	static get OBJECT_STARRED_ARTICLE() {
		return process.env.XAPI_URL + 'starred_article/';
	}

	static get OBJECT_ANSWERED_QUESTION() {
		return process.env.XAPI_URL + 'answered_question/';
	}

	static get OBJECT_ASKED_QUESTION() {
		return process.env.XAPI_URL + 'asked_question/';
	}

	static get OBJECT_CREATED_TEAM() {
		return process.env.XAPI_URL + 'created_team/';
	}

	static get OBJECT_DELETE_MEMBER() {
		return process.env.XAPI_URL + 'deleted_member_from_team/';
	}

	static get OBJECT_DELETED_TEAM() {
		return process.env.XAPI_URL + 'deleted_team/';
	}

	static get OBJECT_REQUESTED_PASSWORD_RESET() {
		return process.env.XAPI_URL + 'requested_password_reset/';
	}

	static get OBJECT_REGISTERED() {
		return process.env.XAPI_URL + 'registered/';
	}

	static get OBJECT_PASSWORD_RESET() {
		return process.env.XAPI_URL + 'reset_password/';
	}

	static get OBJECT_SET_ARTICLE_START_TIME() {
		return process.env.XAPI_URL + 'set_article_start_time/';
	}

	static get OBJECT_SET_ARTICLE_END_TIME() {
		return process.env.XAPI_URL + 'set_article_end_time/';
	}

	static get OBJECT_ADDED_FAVORITE() {
		return process.env.XAPI_URL + 'added_favorite/';
	}

	static get OBJECT_REMOVED_FAVORITE() {
		return process.env.XAPI_URL + 'removed_favorite/';
	}
}