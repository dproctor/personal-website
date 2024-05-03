# Use Ruby image to build the static site
FROM ruby:3.0 as builder

# Set the working directory
WORKDIR /usr/src/app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile* ./

# Install Jekyll and Bundler
RUN bundle install

# Copy the rest of your application into the container
COPY . .

# Build the site
RUN jekyll build

# Use Nginx image to serve the site
FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy a new configuration file from the current directory
COPY nginx.conf /etc/nginx/conf.d

# Copy the built site from the builder stage
COPY --from=builder /usr/src/app/_site /usr/share/nginx/html

# Expose port 8080
EXPOSE 8080

# Start Nginx and keep it running
CMD ["nginx", "-g", "daemon off;"]
# CMD ["nginx", "-t"]
