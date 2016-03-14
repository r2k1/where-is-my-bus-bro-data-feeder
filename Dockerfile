FROM ruby:2.3
RUN bundle install
COPY Gemfile Gemfile
COPY app app
CMD bundle exec ruby app/sync.rb
