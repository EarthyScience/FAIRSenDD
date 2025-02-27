#! /usr/bin/env sh

TAG=latest docker compose build
cwltool fairsendd.cwl#rqa fairsendd.input.yml
