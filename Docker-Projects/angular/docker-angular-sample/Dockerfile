# Stage 1: Build the Angular application
FROM node:24-slim  AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the Angular application with Nginx
FROM nginx:alpine
COPY --from=build /usr/src/app/dist/my-angular-app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
