import { App } from "./app.js";
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

// Initialize app
function setEnv() {
	const __filename = fileURLToPath(import.meta.url);
	const __dirname = path.dirname(__filename);
	dotenv.config({
		path: path.resolve(__dirname, './.env')
	});
}
const app = new App(setEnv);

// Have app listen on given port
app.getApp().listen(app.getPort(), function() {
	console.log(`Server listening on port ${app.getPort()}`);
});
