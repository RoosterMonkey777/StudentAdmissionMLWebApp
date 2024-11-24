# SCript 1: Without NGINX

#!/bin/bash
# Update system and install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
sudo systemctl enable docker

# Log in to AWS Elastic Container Registry (ECR)
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

# Pull and run the Docker container from ECR with restart policy
docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/student-admissions-api:latest
docker run -d --restart unless-stopped -p 5000:5000 <account-id>.dkr.ecr.<region>.amazonaws.com/student-admissions-api:latest



# SCRIPT 2 - With NGNIX

#!/bin/bash
# Update system and install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
sudo systemctl enable docker

# Log in to AWS Elastic Container Registry (ECR)
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<your-region>.amazonaws.com

# Pull and run the Docker container with restart policy
docker pull <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/student-admissions-api:latest
docker run -d --restart unless-stopped -p 5000:5000 <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/student-admissions-api:latest

# Install NGINX
sudo amazon-linux-extras install nginx1.12 -y

# Create directories for the frontend files
sudo mkdir -p /usr/share/nginx/html/frontend
sudo chmod -R 755 /usr/share/nginx/html

# Download frontend files from S3 bucket
aws s3 cp s3://<your-s3-bucket-name>/index.html /usr/share/nginx/html/frontend/
aws s3 cp s3://<your-s3-bucket-name>/styles.css /usr/share/nginx/html/frontend/

# Configure NGINX
sudo tee /etc/nginx/nginx.conf > /dev/null <<EOL
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    server {
        listen 80;

        # Serve frontend files
        location / {
            root /usr/share/nginx/html/frontend;
            index index.html;
        }

        # Proxy backend requests to Flask
        location /predict {
            proxy_pass http://localhost:5000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOL

# Restart NGINX to apply the updated configuration
sudo systemctl restart nginx
sudo systemctl enable nginx
























