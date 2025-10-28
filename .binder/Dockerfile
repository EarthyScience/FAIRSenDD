# repo2docker without this Dockerfile would throw ArgumentError: Package OpenSSL_jll is required
# despite being part of Project.toml. This issue is specific to RQADeforestation.jl

FROM debian:stable-slim AS base
ENV JULIA_VERSION=1.11.4
COPY apt.txt .
RUN \
    # base
    apt-get update && \
    apt-get install -y wget && \
    cat apt.txt | xargs apt-get install -y && \
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

FROM base AS python
COPY environment.yml .
RUN conda env update --file environment.yml --prune --name base

FROM base AS julia
COPY Project.toml /root/.julia/environments/v1.11/Project.toml
COPY Manifest.toml /root/.julia/environments/v1.11/Manifest.toml
RUN julia -e 'using Pkg; Pkg.instantiate(); Pkg.status()'

FROM base AS final
WORKDIR /work
COPY --from=python /root/miniconda3/ /root/miniconda3/
COPY --from=julia /usr/local/bin/julia /usr/local/bin/julia
COPY --from=julia /usr/local/lib/julia /usr/local/lib/julia
COPY --from=julia /root/.julia /root/.julia
COPY fix_gdal.sh .
RUN bash fix_gdal.sh
CMD ["jupyter", "notebook", "--allow-root"]