FROM node:23-alpine
WORKDIR /app
COPY content/package*.json .
RUN npm i
COPY content/* .
EXPOSE 80
CMD npm run docs:dev -- --port 80 --host 0.0.0.0