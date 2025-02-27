FROM python:3.11-slim-bookworm
RUN  pip install --no-cache-dir --upgrade pip pystac pyproj zarr xarray shapely click
COPY stage_out.py /stage_out.py
ENTRYPOINT ["python", "/stage_out.py"]