# Use a slim Python image
FROM python:3.11-slim

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create a non-root user
RUN adduser --disabled-password --gecos '' appuser

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ./simple_time_service.py /app

# Ensure user owns app directory
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port and run app
EXPOSE 5000
CMD ["python", "simple_time_service.py"]

