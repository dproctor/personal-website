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
FROM caddy:alpine

# Copy the built site from the builder stage
COPY --from=builder /usr/src/app/_site /srv

# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Run Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
