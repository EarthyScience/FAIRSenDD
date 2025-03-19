# Development

This site provides information on how to contribute to the development of the FAIRSenDD project.

## ogc-app-cwl

- Julia environment with package RQADeforestation added with url and git commit, e.g. `Pkg.add(url="https://github.com/EarthyScience/RQADeforestation.jl#a611912")`. This is not the local
- CWL runs Docker container in read only mode by default. Only /tmp and and a random home directory are writeable. However, julia needs a writeable depot to fine-adjust packages on startup. Thus, `~/.julia` was added to `JULIA_DEPOT_PATH`.
