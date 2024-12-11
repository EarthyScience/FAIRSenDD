#! /usr/bin/env sh

docker build . -t danlooo/fairsendd
docker push danlooo/fairsendd

cwltool fairsendd.cwl#rqa --continent AF --tile E036N075T3
docker run danlooo/fairsendd AF E036N075T3
docker run --env=HOME=/tmp/YgEokx --user 1234:1234 danlooo/fairsendd AF E036N075T3