# Examples


> [!NOTE]
>
> You can execute this code in an online interactive Jupyter environment
> at Binder:
> [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/danlooo/vitepress-quarto-docker/HEAD)

## Bash

``` bash
echo hello world
```

    hello world

access host docker:

``` bash
docker ps
```

    CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS          PORTS     NAMES
    74484610319b   vitepress-quarto-docker   "/bin/bash quarto re…"   57 seconds ago   Up 57 seconds             keen_margulis
    767e2da69e88   vitepress-quarto-docker   "/bin/bash"              29 minutes ago   Up 29 minutes             mystifying_fermi

## R

``` r
a <- 1
a + 1
```

    [1] 2

## Julia

``` julia
using Dates
using Zarr
Dates.now()
```

    2025-03-14T12:32:15.825

## Python

``` python
import xarray as xr
print("hello world")
```

    hello world
