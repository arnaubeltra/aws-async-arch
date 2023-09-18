from flask import Flask, request, make_response
import secrets
import os
from PIL import Image

import boto3
from botocore.exceptions import ClientError

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)

PROCESSED_IMAGES_FOLDER = './processed_imgs/'
IMAGE_HEIGHT = 800 
IMAGE_WIDTH = 1600

# AWS SES Configuration
SENDER = ""
RECIPIENT = ""
CONFIGURATION_SET = ""
AWS_REGION = ""
SUBJECT = "Your image has been successfuly processed."
BODY_TEXT = "Here you have your image. Enjoy it :)"
CHARSET = "UTF-8"

#client = boto3.client('ses', region_name = AWS_REGION)


@app.route('/processImage', methods = ['POST'])
def processImage():
    if request.method == 'POST':
        try:
            email = request.form['email']
            image = request.files['image']

            img = Image.open(image)
            img = img.resize((IMAGE_WIDTH, IMAGE_HEIGHT))
            image_path = os.path.join(PROCESSED_IMAGES_FOLDER, image.filename)
            img.save(image_path)
            #send_processed_image(image_path)
            
        except Exception as e:
            print(f"An error occurred: {str(e)}")

        return make_response("Success", 200)

    return make_response("Error", 400)

def send_processed_image():
    try:
        response = client.send_email(
            Destination = {
                'ToAddresses': [
                    RECIPIENT,
                ]
            },
            Message = {
                'Body': {
                    'Text': {
                        'Charset': CHARSET,
                        'Data': BODY_TEXT,
                    }
                },
                'Subject': {
                    'Charset': CHARSET,
                    'Data': SUBJECT,
                },
            },
            Source = SENDER,
            ConfigurationSetName = CONFIGURATION_SET
        )
    except ClientError as e:
        print(e.response['Error']['Message'])



if __name__ == '__main__':
    app.run(port = 5001, debug = True)