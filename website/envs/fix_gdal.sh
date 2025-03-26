#!/usr/bin/bash

# Fixes version incompatibility in quarto with JuliaCall
# see https://github.com/katrinabrock/juli-slipRs

mkdir /root/.local
ln -s /usr/lib/x86_64-linux-gnu /root/.local/lib

cat <<EOF >/root/.julia/artifacts/Overrides.toml
[a7073274-a066-55f0-b90d-d619367d196c]
GDAL = "/root/.local"

[02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a]
XML2 = "/root/.local"
EOF
