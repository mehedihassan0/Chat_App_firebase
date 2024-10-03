# Build stage
FROM node:lts-alpine AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and lock files to install dependencies
COPY ["package.json", "package-lock.json*", "./"]

# Install dependencies
RUN npm install --silent

# Copy the rest of the application files
COPY . .

# Build the Vite app for production
RUN npm run build

# Serve stage
FROM nginx:alpine AS production

# Copy the build files to the nginx html directory
COPY --from=build /usr/src/app/dist /usr/share/nginx/html

# Expose port 80 for serving the app
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
