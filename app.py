from flask import Flask, request, jsonify
from pycaret.classification import load_model
import pandas as pd

# Load the PyCaret model
model = load_model('admissions_model')

# Initialize Flask app
app = Flask(__name__)

# Define the predict endpoint
@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Parse JSON input
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['Age', 'Gender', 'Admission Test Score', 'High School Percentage']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'Missing field: {field}'}), 400

        # Extract features
        age = data['Age']
        gender = data['Gender']
        test_score = data['Admission Test Score']
        hs_percentage = data['High School Percentage']

        # Encode gender
        gender_mapping = {'Male': 0, 'Female': 1}
        gender_encoded = gender_mapping.get(gender, -1)

        if gender_encoded == -1:
            return jsonify({'error': 'Invalid value for Gender. Must be "Male" or "Female".'}), 400

        # Create a DataFrame for prediction
        input_data = pd.DataFrame({
            'Age': [age],
            'Gender': [gender_encoded],
            'Admission Test Score': [test_score],
            'High School Percentage': [hs_percentage]
        })

        # Make prediction
        prediction = model.predict(input_data)
        result = prediction[0]

        # Return prediction
        return jsonify({'Admission Status': result})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Health check endpoint
@app.route('/')
def home():
    return "Admission Predictor API is running. Use the /predict endpoint to make predictions."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
