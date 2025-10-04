# Builder stage
FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run ng add @angular/material --theme=indigo-pink --typography=true --animations=true
RUN npm install bootstrap
RUN npm run build 


# Final stage
FROM node:24-alpine
WORKDIR /app
COPY --from=builder /app/dist /app
EXPOSE 4200
CMD ["npm","run","start"]