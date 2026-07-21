FROM ruby:3.2

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

COPY . .

CMD ["./check-task-complete.rb"]
