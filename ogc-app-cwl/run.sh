#! /usr/bin/env sh

docker build . -t danlooo/cwl-example
docker push danlooo/cwl-example
cwltool example.cwl#add-numbers -a 1.2 -b 3.4