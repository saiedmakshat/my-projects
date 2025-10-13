FROM node:18.20-bullseye-slim  as builder
RUN mkdir /project
WORKDIR /project
RUN npm install -g @angular/cli@13
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 4200
#CMD ["npm","run","ng", "build"]
#CMD ["ng", "serve", "--host", "0.0.0.0"]
RUN npm run ng build 

# Final stage
FROM builder as dev-envs
WORKDIR /app
COPY package*.json ./
COPY --from=builder /project/dist /app
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF
EXPOSE 4200
CMD ["npm","run","ng", "serve", "--host", "0.0.0.0"]



# RUN <<EOF
# useradd -s /bin/bash -m vscode
# groupadd docker
# usermod -aG docker vscode
# EOF
# # install Docker tools (cli, buildx, compose)
# COPY --from=gloursdocker/docker / /

# CMD ["ng", "serve", "--host", "0.0.0.0"]