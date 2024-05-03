# Use the official Ruby image as a parent image
FROM ruby:3.0

# Set the working directory
WORKDIR /usr/src/app

EXPOSE 8080

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile* ./

# Install dependencies
RUN bundle install

# Copy the rest of your application into the container
COPY . .

# Build the site
RUN jekyll build

# Install a simple server to serve the static files
RUN gem install webrick

# Start the server
CMD ["ruby", "-run", "-ehttpd", "_site", "-p8080"]
