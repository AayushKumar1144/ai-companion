# Use the official lightweight Nginx image from Docker Hub
FROM nginx:stable-alpine

# Copy your index.html file into the default Nginx web root directory
# This is the file with the SECRET PLACEHOLDERS
# Add an argument to receive the version color (blue or green)
ARG VERSION_COLOR=unknown 
# Create a simple file indicating the version
RUN echo "Version: ${VERSION_COLOR}" > /usr/share/nginx/html/version.txt
COPY index.html /usr/share/nginx/html/index.html

# The Nginx server runs on port 80 by default.
EXPOSE 80

# Command to run Nginx in the foreground when the container starts
CMD ["nginx", "-g", "daemon off;"]