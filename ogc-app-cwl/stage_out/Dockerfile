FROM python:3.11-slim-bookworm
RUN  pip install --no-cache-dir --upgrade pip pystac pyproj zarr==2.18.4 xarray shapely click minio
COPY stage_out.py /stage_out.py
ENTRYPOINT ["python", "/stage_out.py"]