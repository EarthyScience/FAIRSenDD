FROM python:3.11-slim-bookworm
RUN  pip install --no-cache-dir --upgrade pip pystac pyproj
COPY app.py /app.py
ENTRYPOINT ["python", "/app.py"]