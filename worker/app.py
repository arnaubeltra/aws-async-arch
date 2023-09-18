from flask import Flask, request, make_response
import secrets
import os

UPLOAD_FOLDER = './tmp_images/'

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/processImage', methods = ['POST'])
def processImage():
    if request.method == 'POST':
        email = request.form['email']
        image = request.files['image']

        print(email, image.filename)
        image.save(os.path.join(app.config['UPLOAD_FOLDER'], image.filename))

        return make_response("Success", 200)
    return make_response("Error", 400)

if __name__ == '__main__':
    app.run(port = 5001, debug = True)