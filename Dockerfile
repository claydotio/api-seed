FROM node:0.10

# Install Git
RUN apt-get update && apt-get install -y git

# Add source
ADD ./node_modules /opt/api/node_modules
ADD . /opt/api

WORKDIR /opt/api

# Install app deps
RUN npm install

CMD ["npm", "start"]
