# <img src='website/docs/public/logo-fairsendd.png' align="right" height="120px" /> FAIRSenDD: FAIR workflow for Sentinel-1 based Deforestation Detection

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/earthyscience/fairsendd/HEAD)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://earthyscience.github.io/FAIRSenDD)

A project from the Max-Planck-Institute for Biogeochemistry to create a FAIR deforestation detection SaaS as a scientific long-term availability demonstrator for the European Space Agency.

## Overview

This repository contains code and documentation for a FAIR workflow based on the Julia package [RQADeforestation.jl](https://github.com/EarthyScience/RQADeforestation.jl).

| directory                                    | description                                                                                      |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [`RQADeforestation.jl`](RQADeforestation.jl) | git submodule to the underlying Julia package                                                    |
| [`infrastructure`](infrastructure)           | VM setup description using Terraform                                                             |
| [`ogc-api`](ogc-api)                         | OGC API using pygeoapi                                                                           |
| [`ogc-app-cwl`](ogc-app-cwl)                 | OGC Application Package as a CWL workflow                                                        |
| [`website`](website)                         | [Project website](https://earthyscience.github.io/FAIRSenDD) with documentation and workflow GUI |

## Funding

<img src="website/docs/public/ESA_logo.svg" align="left" height="50px"/>
<img src="website/docs/public/ESA_NoR_logo.svg" align="left" height="50px" style="filter: contrast(0);"/>

This project was funded by the European Space Agency in the Science Result Long-Term Availability & Reusability Demonstrator Initiative.
In addition, this project was supported by the ESA Network of Resources.
