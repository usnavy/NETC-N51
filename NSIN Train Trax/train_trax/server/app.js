// Requires
import bodyParser from 'body-parser';
import express from 'express';

// Require endpoints
import login from './endpoints/login.js'; 
import register from './endpoints/register.js'; 
import forgot_password from './endpoints/forgot_password.js'; 
import reset_password from './endpoints/reset_password.js'; 
import get_articles from './endpoints/get_articles.js'; 
import get_favorites from './endpoints/get_favorites.js';
import get_starred from './endpoints/get_starred.js';
import get_all_articles from './endpoints/get_all_articles.js'; 
import add_article from './endpoints/add_article.js';
import set_article_time from './endpoints/set_article_time.js';
import set_favorite from './endpoints/set_favorite.js';
import add_starred from './endpoints/add_starred.js';
import get_users from './endpoints/get_users.js';
import get_user_info from './endpoints/get_user_info.js';
import get_team_info from './endpoints/get_team_info.js';
import get_user_stats from './endpoints/get_user_stats.js';
import get_team_stats from './endpoints/get_team_stats.js';
import get_all_stats from './endpoints/get_all_stats.js';
import create_team from './endpoints/create_team.js';
import delete_team from './endpoints/delete_team.js';
import add_member from './endpoints/add_member.js';
import delete_member from './endpoints/delete_member.js';
import ask_question from './endpoints/ask_question.js';
import answer_question from './endpoints/answer_question.js';
import get_questions_answers from './endpoints/get_questions_answers.js';

export class App {

	constructor(setDotEnv) {
		if (setDotEnv !== undefined) setDotEnv();

		// Create the app
		this.app = express();
		this.port = process.env.PORT ?? 3302;
		this.app.set('port', this.port);

		// Configure app
		this.app.use(bodyParser.json());
		this.app.use(bodyParser.urlencoded({
			extended: true
		}));

		// Login-related Endpoints
		this.app.post('/api/login', login);
		this.app.post('/api/register', register);

		// Password-related endpoints
		this.app.post('/api/forgot_password', forgot_password);
		this.app.post('/api/reset_password', reset_password);

		// Get Articles/Domains endpoints
		this.app.post('/api/get_articles', get_articles);
		this.app.post('/api/get_favorites', get_favorites);
		this.app.post('/api/get_starred_articles', get_starred(false));
		this.app.post('/api/get_starred_domains', get_starred(true));
		this.app.post('/api/get_all_articles', get_all_articles);

		// Modify User Articles endpoints
		this.app.post('/api/add_article', add_article);
		this.app.post('/api/set_article_start_time', set_article_time(true));
		this.app.post('/api/set_article_end_time', set_article_time(false));
		this.app.post('/api/add_favorite', set_favorite(true));
		this.app.post('/api/remove_favorite', set_favorite(false));

		// Modify Starred Articles/Domains endpoints
		this.app.post('/api/add_starred_article', add_starred(false));
		this.app.post('/api/add_starred_domain', add_starred(true));

		// Info endpoints
		this.app.post('/api/get_users', get_users);
		this.app.post('/api/get_user_info', get_user_info);
		this.app.post('/api/get_team_info', get_team_info);

		// Stats-related endpoints
		this.app.post('/api/get_user_stats', get_user_stats);
		this.app.post('/api/get_team_stats', get_team_stats);
		this.app.post('/api/get_all_stats', get_all_stats);

		// Team-related endpoints
		this.app.post('/api/create_team', create_team);
		this.app.post('/api/delete_team', delete_team);
		this.app.post('/api/add_member', add_member);
		this.app.post('/api/delete_member', delete_member);

		// Question and Answer endpoints
		this.app.post('/api/ask_question', ask_question);
		this.app.post('/api/answer_question', answer_question);
		this.app.post('/api/get_questions_answers', get_questions_answers);
	}

	getApp() {
		return this.app;
	}

	getPort() {
		return this.port;
	}
}
