# Stage 1: Build the Angular application
FROM node:18.20-bullseye-slim  AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Stage 2: Serve the Angular application with Nginx
FROM nginx:alpine
COPY --from=build /usr/src/app/dist/expense-tracker /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
