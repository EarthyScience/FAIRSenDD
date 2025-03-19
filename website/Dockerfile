# Environment to execute and render quarto notebooks in R, Python, and Julia

FROM rocker/r-ver:4.4.3 AS base
ENV QUARTO_VERSION=1.5.56
ENV JULIA_VERSION=1.11.4
WORKDIR /build
COPY envs/apt.txt .
RUN \
    # base
    apt-get update && \
    apt-get install -y wget && \
    cat apt.txt | xargs apt-get install -y && \
    # docker
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyring && \ 
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    # quarto 
    apt-get update && \
    apt-get install -y wget && \
    wget -O quarto.deb https://github.com/quarto-dev/quarto-cli/releases/download/v$QUARTO_VERSION/quarto-$QUARTO_VERSION-linux-amd64.deb && \
    apt-get install -y ./quarto.deb && \
    # conda
    wget -O miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py312_25.1.1-2-Linux-x86_64.sh && \
    mkdir -p /root/.conda && \
    bash miniconda.sh -b -p /root/miniconda3 && \
    rm -f miniconda.sh && \
    /root/miniconda3/bin/conda init && \
    # julia
    wget -O julia.tar.gz https://julialang-s3.julialang.org/bin/linux/x64/1.11/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    tar zxvf julia.tar.gz && \
    mv julia-${JULIA_VERSION} /usr/local/lib/julia && \
    ln -s /usr/local/lib/julia/bin/julia /usr/local/bin/
ENV PATH="/root/miniconda3/bin:$PATH"

FROM base AS r
COPY envs/install.R .
RUN Rscript install.R

FROM base AS python
COPY envs/environment.yml .
RUN conda env update --file environment.yml --prune

FROM base AS julia
COPY envs/Project.toml /root/.julia/environments/v1.11/Project.toml
COPY envs/Manifest.toml /root/.julia/environments/v1.11/Manifest.toml
RUN julia -e 'using Pkg; Pkg.instantiate(); Pkg.status()'

FROM base AS final
WORKDIR /work
COPY --from=r /usr/local/lib/R/site-library /usr/local/lib/R/site-library
COPY --from=python /root/miniconda3/ /root/miniconda3/
COPY --from=julia /usr/local/bin/julia /usr/local/bin/julia
COPY --from=julia /usr/local/lib/julia /usr/local/lib/julia
COPY --from=julia /root/.julia /root/.julia
ENTRYPOINT [ "/bin/bash" ]