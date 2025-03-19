docker build -t vitepress-quarto-docker .
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/docs:/work vitepress-quarto-docker quarto render .
npm run docs:dev
