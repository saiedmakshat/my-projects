FROM --platform=$BUILDPLATFORM node:18.20-bullseye-slim  as builder
RUN mkdir /project
WORKDIR /project
RUN npm install -g @angular/cli@13
RUN npm install -g npm@7.6.0

COPY package.json package-lock.json ./
RUN yarn version --new-version 1.22.22
RUN npm install
RUN npm ci
COPY . .
CMD ["ng", "serve", "--host", "0.0.0.0"]

FROM builder as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF
RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD ["ng", "serve", "--host", "0.0.0.0"]