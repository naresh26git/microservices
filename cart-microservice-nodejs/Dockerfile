FROM node:8
RUN echo " Try to build my application"
COPY . .
WORKDIR /app
RUN npm install
EXPOSE 1004
ENTRYPOINT ["npm","start","index.js","node"]
