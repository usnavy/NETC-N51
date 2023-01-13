# import libraries  
import io 
from PIL import Image
from BackEnd.Python.s3upload import upload_to_aws
from BackEnd.Python.New_Image_Text import TesseractMain
import os

#Bucket name for AWS
BUCKET_NAME = 'netc-filestorage'

# iterate over PDF pages 
def IteratePDF (pdf_file, filename):


    for page_index in range(len(pdf_file)): 
        # get the page itself 
        page = pdf_file[page_index] 

        image_list = page.get_images() 

        # printing number of images found in this page 
        if image_list: 

            print(f"[+] Found a total of {len(image_list)} images in page {page_index}") 

        else: 

            print("[!] No images found on page", page_index) 

        for image_index, img in enumerate(page.get_images(), start=1): 

            # get the XREF of the image 
            xref = img[0] 

            # extract the image bytes 
            base_image = pdf_file.extract_image(xref) 

            image_bytes = base_image["image"] 

            # get the image extension 
            image_ext = base_image["ext"] 

            # load it to PIL
            image = Image.open(io.BytesIO(image_bytes))

            image_path = os.path.dirname(__file__)
        
            # save it to local disk
            image.save(open(f"{image_path}/image{page_index+1}_{image_index}.{image_ext}", "wb"))

            imagename = f"image{page_index+1}_{image_index}.{image_ext}"

            #uploads to AWS and removes images locally
            uploaded = upload_to_aws(os.path.dirname(__file__) + "/" + imagename,BUCKET_NAME,'Image-Storage/' + filename + "/"  + imagename)
            
            #TesseractMain(image_path,imagename,filename)

            os.remove(os.path.dirname(__file__) + "/" + imagename)



