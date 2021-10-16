FROM node:dubnium AS dist
COPY package.json ./

RUN npm install

COPY . ./

RUN npm run-script build

FROM node:dubnium AS node_modules
COPY package.json ./
RUN npm install --prod


FROM node:dubnium

ARG PORT=8080

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY --from=dist dist /usr/src/app/dist
COPY --from=node_modules node_modules /usr/src/app/node_modules

COPY . /usr/src/app

RUN apt-get update
RUN apt install python3-pip -y
RUN apt-get install python3-lxml -y
RUN apt-get install attr -y

EXPOSE $PORT

CMD [ "npm", "run-script", "start:prod" ]
