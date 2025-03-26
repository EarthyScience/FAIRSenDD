set -e
docker build -t danlooo/fairsendd_environment .
# cwltool needs to mount docker service and /tmp data dir
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /tmp:/tmp \
    -v $PWD/docs:/work \
    danlooo/fairsendd_environment quarto render .
npm run docs:dev
