FROM node:latest
MAINTAINER Naresh
RUN echo "try to build my application"
WORKDIR /app 
COPY . .
RUN npm install
EXPOSE 1004
ENTRYPOINT ["npm","start"]
CMD ["node","index.js"]
