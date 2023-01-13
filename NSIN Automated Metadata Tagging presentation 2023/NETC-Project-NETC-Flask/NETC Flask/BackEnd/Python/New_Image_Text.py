# extract text from all the images in a folder
# storing the text in a single file
from PIL import Image
import pytesseract as pt
import os
from BackEnd.Python.s3upload import upload_to_aws

#Bucket name for AWS
BUCKET_NAME = 'netc-filestorage'
	
def TesseractMain(ImagePath,imageName,fileName):


	fullTempPath = os.path.dirname(__file__) + "/" + "outputFile.txt"

	# iterating the images inside the folder
	inputPath = os.path.join(ImagePath, imageName)
	img = Image.open(inputPath)

	# applying ocr using pytesseract for python
	#pt.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
	text = pt.image_to_string(img, lang ="eng")

	# saving the text for appending it to the output.txt file
	# a + parameter used for creating the file if not present
	# and if present then append the text content
	file1 = open(fullTempPath, "a+")

	# providing the name of the image
	file1.write(imageName+"\n")

	# providing the content in the image
	file1.write(text+"\n")
	file1.close()

	# for printing the output file
	file2 = open(fullTempPath, 'r')
	#print(file2.read())
	file2.close()

	uploaded = upload_to_aws(fullTempPath,BUCKET_NAME,'Image-Text-Storage/' + fileName + "/Output.txt")

	os.remove(fullTempPath)		



