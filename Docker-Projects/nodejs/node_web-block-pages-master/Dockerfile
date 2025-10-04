FROM node:slim
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN npm audit fix
COPY . .
EXPOSE 8560-8568
CMD [ "npm" ,"run" ,"start" ]