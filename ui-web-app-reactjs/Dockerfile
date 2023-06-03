FROM node:latest
WORKDIR /app
COPY . .

RUN npm install express
RUN npm install

EXPOSE 3000

#Runs in development Mode
CMD ["npm", "start"]
