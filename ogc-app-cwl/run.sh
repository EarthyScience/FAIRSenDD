#! /usr/bin/env sh

docker build RQADeforestation.jl -t danlooo/rqa_deforestation:latest
cwltool fairsendd.cwl#rqa --continent EU --tiles E051N018T3 --in-dir ../RQADeforestationTestData
