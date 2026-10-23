FROM node:20-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

ENV NODE_OPTIONS="--openssl-legacy-provider"
RUN npx webpack -c ./webpack.config.js

EXPOSE 3000

CMD ["node", "app.js"]
