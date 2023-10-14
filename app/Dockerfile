FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
ENV NODE_ENV production
EXPOSE 80
CMD [ "node", "dist/index.js" ]