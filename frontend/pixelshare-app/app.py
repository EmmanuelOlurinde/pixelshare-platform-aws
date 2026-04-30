from flask import Flask, request, render_template, redirect, url_for
import boto3
import os
import json

app = Flask(__name__)

# -----------------------------
# Load DB credentials from Secrets Manager
# -----------------------------
secrets_client = boto3.client("secretsmanager")
secret_name = "pixelshare-db-credentials"  # must match your Terraform name

secret_value = secrets_client.get_secret_value(SecretId=secret_name)
db_creds = json.loads(secret_value["SecretString"])

DB_USER = db_creds["username"]
DB_PASS = db_creds["password"]

# -----------------------------
# S3 Configuration
# -----------------------------
S3_BUCKET = "pixelshare-images"  # must match your Terraform bucket
s3 = boto3.client("s3")

@app.route("/", methods=["GET"])
def index():
    # List images from S3
    objects = s3.list_objects_v2(Bucket=S3_BUCKET)
    images = []

    if "Contents" in objects:
        for obj in objects["Contents"]:
            images.append(obj["Key"])

    return render_template("index.html", images=images)

@app.route("/upload", methods=["POST"])
def upload():
    file = request.files["photo"]
    if file:
        s3.upload_fileobj(
            file,
            S3_BUCKET,
            file.filename,
            ExtraArgs={"ContentType": file.content_type}
        )
    return redirect(url_for("index"))

@app.route("/image/<filename>")
def image(filename):
    # Generate a temporary signed URL
    url = s3.generate_presigned_url(
        "get_object",
        Params={"Bucket": S3_BUCKET, "Key": filename},
        ExpiresIn=3600
    )
    return redirect(url)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
