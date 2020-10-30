FROM node:8
# Create app directory
WORKDIR /app
COPY package*.json ./
# RUN npm -install
RUN npm install -g npm@latest
# Bundle app source
COPY . .
EXPOSE 5000
CMD [ "npm", "start" ]

FROM node:8
# Create app directory
WORKDIR /api
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json  ./
# RUN npm -install
RUN npm install -g npm@latest
# Bundle app source
COPY . .
EXPOSE 8080
CMD [ "npm", "start-api" ]