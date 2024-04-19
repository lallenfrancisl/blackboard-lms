# README

## About 
Blackboard-lms serves as an LMS platform tailored to meet the training demands of the hotel and hospitality industry. Blackboard-lms is an open-source project developed using the Ruby On Rails framework.

### Running in local

Install ruby 3.2.0 using rbenv or rvm

```
# install bundler
$ gem install bundler

# install dependencies
$ bundle install

# create & setup database
$ rails db:create
$ rails db:migrate
$ rails db:seed

# install node & flowbite

$ npm install flowbite

# start server
$ rails s
```