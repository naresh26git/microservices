FROM node:latest
MAINTAINER Naresh
RUN echo "try to build my application"
WORKDIR /app 
COPY . .
RUN npm install
EXPOSE 8080
ENTRYPOINT ["npm","start"]
CMD ["node","index.js"]
