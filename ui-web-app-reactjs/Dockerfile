FROM node:8
WORKDIR /app
#COPY package*.json ./

#RUN npm install express
COPY . .
RUN npm install

EXPOSE 3000

#Runs in development Mode
CMD ["npm", "start","build"]
