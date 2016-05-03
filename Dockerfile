FROM node

ADD . /proj

WORKDIR /proj

RUN npm i

CMD ["npm", "start"]
