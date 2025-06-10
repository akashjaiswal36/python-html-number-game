# 🏗️ Build stage
FROM python:3.11-slim as builder

WORKDIR /app
COPY . .

# Install Python packages into /app/venv
RUN pip install --upgrade pip && \
    pip install --target=/app/venv -r requirements.txt

# 🚀 Final Image (distroless)
FROM gcr.io/distroless/python3-debian11

WORKDIR /app

COPY --from=builder /app /app
COPY --from=builder /app/venv /app/venv

ENV PYTHONPATH=/app/venv

EXPOSE 5000

CMD ["app.py"]
