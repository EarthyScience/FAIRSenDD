#! /usr/bin/env sh

docker build . -t danlooo/fairsendd
# docker push danlooo/fairsendd
cwltool fairsendd.cwl#rqa --continent NA --tile E036N075T3 --in-dir ../etc/data/eodc/products/eodc.eu/S1_CSAR_IWGRDH/SIG0/ 