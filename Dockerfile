# Start with the base Python image
FROM python:3.10-slim

# Install dependencies required by LightGBM or other libraries
RUN apt-get update && apt-get install -y libgomp1

# Set the working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port
EXPOSE 5000

# Command to run the app
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]