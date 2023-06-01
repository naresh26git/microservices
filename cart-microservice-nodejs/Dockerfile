FROM node:14
USER root
WORKDIR /app 
COPY . .
RUN npm run build
EXPOSE 1004
CMD ["node","index.js"]
