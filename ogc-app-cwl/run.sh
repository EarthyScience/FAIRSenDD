#! /usr/bin/env sh

export TAG=latest
docker compose build

cwltool fairsendd.cwl#rqa \
    --continent EU \
    --tiles E051N018T3 \
    --start-date 2021-01-01 \
    --end-date 2022-01-01 \
    --in-dir ../RQADeforestationTestData \
    --out-dir test1 \
    --access-key $AWS_ACCESS_KEY_ID \
    --secret-key $AWS_SECRET_ACCESS_KEY
