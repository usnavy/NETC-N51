from flask import Flask, render_template, request, redirect, url_for, flash, Response
from flask_bootstrap import Bootstrap
from werkzeug.utils import secure_filename
from BackEnd.Python.s3upload import upload_to_aws
from BackEnd.Python.Image_Extraction import IteratePDF
from BackEnd.Python.PDF_Selection import openFile
from BackEnd.Python.s3content import get_bucket
from BackEnd.Python.filters import datetimeformat, file_type
import os
import fitz


app = Flask(__name__,template_folder='FrontEnd',static_folder='static')
Bootstrap(app)
app.jinja_env.filters['datetimeformat'] = datetimeformat
app.jinja_env.filters['file_type'] = file_type


BUCKET_NAME = 'netc-filestorage'

#routes to html pages

#initial page
@app.route('/')
def index():
    return render_template('index.html')

#Home Page
@app.route('/home')
def home():
    return render_template('index.html')

#displaying S3 bucket
@app.route('/DisplayFiles')
def files():
    my_bucket = get_bucket()
    summaries = my_bucket.objects.all()

    #Folders
    fileStorage = my_bucket.objects.filter(Prefix='File-Storage/')
    imageStorage = my_bucket.objects.filter(Prefix='Image-Storage/')
    metaStorage = my_bucket.objects.filter(Prefix='Meta-Data-Storage/')
    videoStorage = my_bucket.objects.filter(Prefix='Video-File-Storage/')

    return render_template('Display.html', my_bucket=my_bucket, files=fileStorage, images=imageStorage, meta=metaStorage, videos=videoStorage)

#Downloading File
@app.route('/download', methods=['POST'])
def download():
    key = request.form['key']

    my_bucket = get_bucket()
    file_obj = my_bucket.Object(key).get()

    return Response(
        file_obj['Body'].read(),
        mimetype='text/plain',
        headers={"Content-Disposition": "attachment;filename={}".format(key)}
    )


#PDF Upload page
@app.route('/PDF-upload')
def PDFupload():
    return render_template('PDF-upload.html')

#Upload to AWS
@app.route('/AWS-File-upload',methods=['post'])
def upload():
    if request.method == 'POST':
        img = request.files['file']
        if img:
                filename = secure_filename(img.filename)
                img.save(filename)
                uploaded = upload_to_aws(filename,BUCKET_NAME,'File-Storage/' + filename)
                msg = "Upload Done ! "

    #Opens file and runs Image Extraction, closes and removes file after
    pdf_file = fitz.open(os.path.dirname(__file__) + "/" + filename)
    FilePath = os.path.dirname(__file__) + "/" + filename
    IteratePDF(pdf_file, filename)

    openFile(FilePath,filename)

    pdf_file.close()
    os.remove(filename)


    return redirect(url_for('files'))

#Video Upload page
@app.route('/video-upload')
def videoupload():
    return render_template('video-upload.html')

#upload to AWS
@app.route('/AWS-Video-File-upload',methods=['post'])
def AWSVideoupload():
    if request.method == 'POST':
        img = request.files['file']
        if img:
                filename = secure_filename(img.filename)
                img.save(filename)
                uploaded = upload_to_aws(filename,BUCKET_NAME,'Video-File-Storage/' + filename)
                msg = "Upload Done ! "

    os.remove(filename)

    return redirect(url_for('files'))


if __name__ == '__main__':
    app.run(debug=True)
