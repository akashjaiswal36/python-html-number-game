# 🏗️ Build stage
FROM python:3.11-slim AS builder

WORKDIR /app
COPY . .

# Install dependencies into a target directory
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --target /app/venv -r requirements.txt

# ✂️ Final minimal image using distroless
FROM gcr.io/distroless/python3

WORKDIR /app

# Copy app code and dependencies from builder
COPY --from=builder /app /app
COPY --from=builder /app/venv /app/venv

# Set PYTHONPATH to use venv as library path
ENV PYTHONPATH=/app/venv

# Expose Flask port
EXPOSE 5000

# Start app with absolute path to Python entrypoint
CMD ["/usr/bin/python3", "app.py"]
