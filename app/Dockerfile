# Use an official Node.js runtime as a parent image (specific version)
FROM node:14.17.0 as build

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json (if available) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the application (if there is any build step)
# RUN npm run build  # Uncomment this line if there's a build step

# Create a new stage for the production image
FROM node:14.17.0-alpine

# Set the working directory in the container to /app
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app .

# Add a non-root user and use it
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Define the command to run the application
CMD ["node", "server.js"]
