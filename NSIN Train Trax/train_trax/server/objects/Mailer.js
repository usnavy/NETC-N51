import nodemailer from 'nodemailer';

export default class Mailer {

	static getMailer() {
		if (Mailer.mailer === undefined) {
			Mailer.mailer = nodemailer.createTransport({
				service: 'gmail',
				secure: true,
				auth: {
					user: process.env.GMAIL_USERNAME,
					pass: process.env.GMAIL_PASSWORD
				}
			});
		}

		return Mailer.mailer;
	}

	static async sendEmail(to, subject, text, html = undefined) {
		const payload = {
			from: 'Train Trax <traintraxexperience@gmail.com>',
			to, subject, text
		};
		if (html !== undefined) payload.html = html;

		let ret = null;
		await Mailer.getMailer().sendMail(payload)
			.then(res => ret = res)
			.catch(err => console.error('Error sending email', err.stack));
		return ret;
	}
}