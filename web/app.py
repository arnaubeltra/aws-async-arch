from flask import Flask, render_template, request, url_for, flash, redirect
import secrets
import requests
import os

SECRET_KEY = secrets.token_hex(16)
UPLOAD_FOLDER = './tmp_images/'
URL_WORKER = 'http://localhost:5001/processImage'

app = Flask(__name__)
app.secret_key = SECRET_KEY
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/', methods = ['GET', 'POST'])
def index():
    if request.method == 'POST':
        email = request.form['email']
        image = request.files['image']

        if not email:
            status_message = "Email is required"
            return render_template('index.html', status_message = status_message)    
        
        if not image:
            status_message = "Image is required"
            return render_template('index.html', status_message = status_message)
        
        else:
            random_hex = secrets.token_hex(8)
            image_filename = random_hex + "_" + image.filename
            image_path = os.path.join(app.config['UPLOAD_FOLDER'], image_filename)
            image.save(image_path)

            status = process_image(image_path, email)
            
            if status == True:
                os.remove(image_path)
                status_message = "The processed image will be sent to " + email
                return render_template('index.html', status_message = status_message)
            
            else:
                status_message = "Error processing image"
                return render_template('index.html', status_message = status_message)
    
    return render_template('index.html')

def process_image(image_path, email):
    payload = {'email': email}
    image = {'image': open(image_path, 'rb')}
    response = requests.post(URL_WORKER, data = payload, files = image)

    if response.status_code == 200:
        return True
    return False


if __name__ == '__main__':
    app.run(debug=True)