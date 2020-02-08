FROM ruby:2.6.3
ENV APP_HOME /stocks-obs
ENV BUNDLER_VERSION="2.0.2"
# Installation of dependencies
RUN apt-get update -qq \
  && apt-get install -y \
      # Needed for certain gems
    build-essential \
         # Needed for postgres gem
    libpq-dev \
    nodejs \
    # The following are used to trim down the size of the image by removing unneeded data
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log
# Create a directory for our application
# and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
# Add our Gemfile and install gems
ADD Gemfile* $APP_HOME/
RUN gem install bundler --version "${BUNDLER_VERSION}"
# Copy over our application code
ADD . $APP_HOME
RUN bundle install
# Run our app
CMD RAILS_ENV=${RAILS_ENV} bundle exec rails db:create db:migrate db:seed && bundle exec rails s -p ${PORT} -b '0.0.0.0'
