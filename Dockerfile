FROM node:16

WORKDIR /app

COPY package.json .

RUN npm install

RUN npm install socket.io

RUN npm install socket.io mysql

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]

CMD ["npm", "start"]
