# Use the official Node.js image as a parent image
FROM node:14-alpine as build

# Set the working directory in the Docker container
WORKDIR /app

# Copy the package.json and package-lock.json files into the container at /app
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the local files into the container at /app
COPY . .

# Build the application
RUN npm run build

# Start from a smaller image to reduce image size
FROM node:14-alpine as run

# Set the working directory in the Docker container
WORKDIR /app

# Copy over dependencies
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package*.json ./

# Expose port 3000 for the app to be accessible externally
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]