FROM node:12-alpine AS build

# Define working directory
WORKDIR /src

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# Install dependencies
RUN npm ci --production

# Bundle app source
COPY . .

RUN npm run build:alpine

FROM node:12-alpine

# Define working directory
WORKDIR /app

COPY --from=build /src/gitlab-release-note-generator /usr/bin/gitlab-release-note-generator

RUN chown node:node /usr/bin/gitlab-release-note-generator

USER node

CMD ["gitlab-release-note-generator"]