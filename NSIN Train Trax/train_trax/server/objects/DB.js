import pg from 'pg';

export default class DB {

	static getPool() {
		if (DB.pool === undefined) {
			DB.pool = new pg.Pool({
				connectionString: process.env.DATABASE_URL,
				ssl: {
					rejectUnauthorized: false
				}
			});
			DB.pool.connect();
		}

		return DB.pool;
	}

	static async query(sql, values = []) {
		let ret = [];
		await DB.getPool().query(sql, values)
			.then(res => ret = res.rows)
			.catch(err => console.error('Error executing query', err.stack));
		return ret;
	}
}
