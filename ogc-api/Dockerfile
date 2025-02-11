FROM geopython/pygeoapi:0.19.0
WORKDIR /app
EXPOSE 80

RUN apt-get update && \
    apt-get install -y curl git && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

RUN pip3 install kubernetes==28.1.0 loguru && \
    pip3 install git+https://github.com/terradue/pycalrissian@0.6.3

COPY ./pygeoapi-config.yml /pygeoapi/local.config.yml
COPY ./rqa-deforestation.py /pygeoapi/pygeoapi/process/