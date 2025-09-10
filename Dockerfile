# Use the official Nginx image as base
FROM nginx:alpine

# Copy the HTML file to the Nginx web directory
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
