## ReactJS  Application with cypress

This is a quick implementation of a ReactJS with cypress using dockerfile and docker-compose.yaml file, this implementations helps to do e2e testing and intergrating result into testrail. actually its possible to run dockerfile and docker-compose, but due to technical diffculty and internet slowness to download images, I could not spend more time to fix those issue. I have good idea, how to execute this project.

A ReactJS application with cypress  is usually made of 2  main container - 

container1 :api
               container run in node:8 with port 5000, command to start "npm start"
               and in node:8 with port 8080, command to start "npm start-api"
container2 :cypress
               container run cypress with all feature file from integration folder and report to testrail.

few new files added,scripts/wait_for_it.sh is used to wait for the ReactJS application up running for the cypress container.

As already stated this project implementation is not fully completed due technical diffculty and slowness. I am providing my solution as much as possible i can.

The entry point for a user is a website which is available under the address: **http://localhost:5000/#**

![diagram](https://github.com/kunnath/cypressdemo/blob/master/assets/cypress.png)



---

### Prerequisites

In order to run this application you need to install two tools: **Docker** & **Docker Compose**.


### How to run it?

The entire application can be run with a single command on a terminal:

```
$ docker-compose up -d
```

If you want to stop it, use the following command:

```
$ docker-compose down
```

---

#### api ( sqlite3 database and reactjs Frontend)

flask, sqlite3 database contains  schema with tables - providing the front end url
and sqlite3 contain table.

After running the api it can be accessible using these 5000 port:

- Host: *localhost*
- Database: *sqlite3*


*docker-compose.yml* file.

```yml
version: '3.2'
services:
  api:
    build: .
    environment:
      - PORT=5000
  cypress:
    image: "cypress/included:4.4.0"
    depends_on:
      - api
    entrypoint: /scripts/wait_for_it.sh api:5000 -- cypress run
    environment:
      - CYPRESS_baseUrl=http://api:5000
    working_dir: /e2e
    volumes:
      - ./:/e2e
```

```dockerfile

FROM node:8
# Create app directory
WORKDIR /app
COPY package*.json ./
# RUN npm clean-install
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
# RUN npm clean-install
RUN npm install -g npm@latest
# Bundle app source
COPY . .
EXPOSE 8080
CMD [ "npm", "start-api" ]

```

#### cypress (cypress run in e2e folder)

entrypoint: /scripts/wait_for_it.sh api:5000 -- cypress run
following above entrypoint wait for the api url up and running

#### cypress json (testrail inegration)
cypress.json provide the testrail intergration for the execution result.

```json
{
  "baseUrl": "http://localhost:5000/#",
  "testFiles": "**/*.feature",
  "experimentalNetworkStubbing": true,
  "pluginsFile": false,
  "supportFile": false,
  "reporter": "cypress-testrail-reporter",
  "reporterOptions": {
      "domain": "pinksandbox.testrail.io",
      "username": "qa@qa.qa",
      "password": "Test1234",
      "projectId": 2,
      "suiteId": 2
  }
}
```
I could not validate the projectId ,suiteId ,hence proving the default value.


