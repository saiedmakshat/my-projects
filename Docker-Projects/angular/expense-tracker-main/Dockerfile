# FROM node:slim
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run ng add @angular/material
# RUN npm install bootstrap
# EXPOSE 4200
# CMD [ "npm","ng","serve" ]


# Builder stage
FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run ng add @angular/material
RUN npm install bootstrap
RUN npm run build 


# Final stage
FROM node:24-alpine
WORKDIR /app
COPY --from=builder /app/dist /app
EXPOSE 4200
CMD ["npm","run","start"]
