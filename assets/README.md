## ReactJS  Application with cypress

This is a quick implementation of a ReactJS with cypress using dockerfile and docker-compose.yaml file, this implementations helps to do e2e testing and intergrating result into testrail. actually its possible to run dockerfile and docker-compose, but due to technical diffculty and internet slowness to download images, I could not spend more time to fix those issue. I have good idea, how to execute this project.

A ReactJS application with cypress  is usually made of 2  main container - 

Container1 : 

            api container run in node:8 with command "npm start" with port: 5000 and using "start react-scripts"

            in node:8 command start "npm start-api" with port 8080 ,"app.py" script to run flask run.


Container2 :

            cypress container run cypress with all feature file from integration folder and report to testrail.



 new files added, "scripts/wait_for_it.sh" this file used to wait for the ReactJS application up running for the cypress container.


As already stated this project implementation is not fully completed due to technical diffculty and internet slowness.
          I am providing my solution as much as possible i can.

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


#### docker-compose.yml* file.

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

#### dockerfile * file.


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

following above entrypoint is waiting for the api url up and running , running the cypress


#### cypress json (testrail integration)


cypress.json provide the testrail intergration for the execution result.

#### *cypress.json* file.

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

I could not validate the projectId ,suiteId .Hence proving the default value.


