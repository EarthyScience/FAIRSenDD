#!/bin/sh

rm -rf content/out.zarr
ls content/*.qmd | xargs -i -P 4 quarto render {}
docker compose up --build
