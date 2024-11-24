## Student Admissions Predictor API
# A machine learning-powered API and web application to predict student admission status based on key factors like age, gender, test scores, and high school percentage.

Features
Frontend: HTML/CSS user interface served via NGINX.
Backend: Flask-based API containerized with Docker and deployed on AWS EC2.
Machine Learning: Pre-trained model for predicting admission status.
AWS Services Used:
EC2: Application hosting.
S3: Frontend file storage.
ECR: Docker image repository.
Elastic IP: Static IP for consistent access.
Tech Stack
Languages: Python, HTML, CSS, JavaScript
Backend Framework: Flask
Frontend: HTML/CSS
Deployment: Docker, AWS (EC2, S3, ECR)
ML Framework: Scikit-learn
Setup Instructions
1. Clone the Repository
bash
Copy code
git clone https://github.com/RoosterMonkey777/StudentAdmissionMLWebApp.git
cd admission-predictor
2. Backend Setup
Build and push the Docker image to AWS ECR:

bash
Copy code
docker build -t student-admissions-api .
docker tag student-admissions-api <account-id>.dkr.ecr.<region>.amazonaws.com/student-admissions-api
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/student-admissions-api
Launch an EC2 instance and use the user data script in this repo to:

Install Docker and NGINX.
Pull the Docker image from ECR.
Fetch and serve the frontend files from S3.
3. Frontend Setup
Upload index.html and styles.css to your S3 bucket.
Ensure EC2 instance has access to your S3 bucket.
Usage
Access the App: Visit the Elastic IP in your browser (e.g., http://<elastic-ip>).
Make Predictions: Fill out the form and submit to get an admission status (Accepted/Rejected).


![image](https://github.com/user-attachments/assets/c8088c07-ed18-4e67-ac2f-0c837d18f8ce)


![image](https://github.com/user-attachments/assets/848bd0e4-abfd-4e83-8e1a-0062dd70d50d)


![image](https://github.com/user-attachments/assets/e6c10ba9-7bea-4653-adc3-02c9837bd6dd)



