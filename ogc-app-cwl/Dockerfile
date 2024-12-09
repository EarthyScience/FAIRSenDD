FROM julia:1.11.2-bookworm
WORKDIR /work

ENV JULIA_PROJECT=/work
ENV JULIA_NUM_THREADS=auto

COPY Project.toml .
COPY Manifest.toml .
RUN julia -e 'using Pkg; Pkg.instantiate()'

ADD run.jl ./
ENTRYPOINT ["/work/run.jl"]
