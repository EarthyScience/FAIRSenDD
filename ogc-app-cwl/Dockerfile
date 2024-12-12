FROM julia:1.11.2-bookworm
WORKDIR /work

ENV JULIA_NUM_THREADS=auto

ENV JULIA_DEPOT_PATH=/.julia
RUN julia -e 'using Pkg; Pkg.activate("/.julia/environments/v1.11"); Pkg.instantiate(); Pkg.status()'
COPY Project.toml /.julia/environments/v1.11/
COPY Manifest.toml /.julia/environments/v1.11/
RUN julia -e 'using Pkg; Pkg.activate("/.julia/environments/v1.11"); Pkg.instantiate(); Pkg.status()'
ENV JULIA_DEPOT_PATH=~/.julia:/.julia

ADD run.jl ./
ENTRYPOINT ["/work/run.jl"]