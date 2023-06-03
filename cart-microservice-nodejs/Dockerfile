FROM node:8
RUN echo " Try to build my application"
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
EXPOSE 1004
ENTRYPOINT ["npm","start"]
