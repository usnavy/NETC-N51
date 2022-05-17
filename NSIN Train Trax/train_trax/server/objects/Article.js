import DB from './DB.js';

export default class Article {

	// Modify User Starred Articles
	static async addStarred(user_id, article, is_domain) {
		return DB.query('INSERT INTO starred_articles(user_id, article, is_domain) VALUES($1, $2, $3);', [user_id, article, is_domain]);
	}

	static async removeStarred(article_id) {
		return DB.query('DELETE FROM starred_articles WHERE article_id = $1;', [article_id]);
	}

	// Get All Starred Articles
	static async getStarredArticles() {
		return DB.query('SELECT DISTINCT article FROM starred_articles WHERE NOT is_domain;');
	}

	static async getStarredDomains() {
		return DB.query('SELECT DISTINCT article FROM starred_articles WHERE is_domain;');
	}

	// Get User Starred Articles
	static async getStarredArticlesFromUser(user_id) {
		return DB.query('SELECT * FROM starred_articles WHERE user_id = $1 AND NOT is_domain;', [user_id]);
	}

	static async getStarredDomainsFromUser(user_id) {
		return DB.query('SELECT * FROM starred_articles WHERE user_id = $1 AND is_domain;', [user_id]);
	}

	// Get User Articles
	static async getArticlesFromUser(user_id) {
		return DB.query('SELECT * FROM articles WHERE user_id = $1;', [user_id]);
	}

	static async getArticlesFromUsers(user_ids) {
		return DB.query('SELECT * FROM articles WHERE user_id = ANY ($1);', [user_ids]);
	}

	// Modify User Favorites
	static async setFavorite(article_id, favorite) {
		return DB.query('UPDATE articles SET is_favorite = $1 WHERE article_id = $2;', [favorite, article_id]);
	}

	// Get User Favorites
	static async getFavoritesFromUser(user_id) {
		return DB.query('SELECT * FROM articles WHERE user_id = $1 AND is_favorite;', [user_id]);
	}

	// Modify Article Time
	static async setStart(article_id, start_time) {
		return DB.query('UPDATE articles SET start_time = $1 WHERE article_id = $2;', [start_time, article_id]);
	}
	
	static async setEnd(article_id, end_time) {
		return DB.query('UPDATE articles SET complete_time = $1 WHERE article_id = $2;', [end_time, article_id]);
	}
	
	// Get Articles
	static async getArticleFromId(article_id) {
		return DB.query('SELECT * FROM articles WHERE article_id = $1;', [article_id]).then(value => value[0]);
	}

	static async getArticles() {
		return DB.query('SELECT DISTINCT article FROM articles;');
	}

	static async getStartedArticlesFromUser(user_id) {
		return DB.query('SELECT * FROM articles WHERE user_id = $1 AND start_time IS NOT NULL;', [user_id]);
	}

	static async getCompletedArticlesFromUser(user_id) {
		return DB.query('SELECT * FROM articles WHERE user_id = $1 AND complete_time IS NOT NULL;', [user_id]);
	}

	// Insert
	static async add(user_id, article, start_time) {
		if (start_time === undefined) {
			return DB.query('INSERT INTO articles(user_id, article, is_favorite) VALUES($1, $2, FALSE);', [user_id, article]);
		} else {
			return DB.query('INSERT INTO articles(user_id, article, start_time, is_favorite) VALUES($1, $2, $3, FALSE);', [user_id, article, start_time]);
		}
	}
}
