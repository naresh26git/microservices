FROM node:8
RUN echo " Try to build my application"
COPY . /var/www
WORKDIR /var/www
RUN npm install
EXPOSE 3000
# EXPOSE 31448
ENTRYPOINT ["npm","start"]
