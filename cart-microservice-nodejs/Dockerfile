# Base image
FROM node:14 as builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
#COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the project files
COPY . .

# Build the React app
RUN npm run build
