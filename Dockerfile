FROM node:12

WORKDIR /app

COPY package*.json 

RUN npm install

RUN npm install socket.io

RUN npm install socket.io mysql

COPY . .

EXPOSE 8080

CMD ["node", "server.js"]
