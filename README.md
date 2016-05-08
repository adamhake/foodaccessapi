# Food Access API

[![Circle CI](https://circleci.com/gh/codeforrva/foodaccessapi.svg?style=svg)](https://circleci.com/gh/codeforrva/foodaccessapi)

API and store resource manager for the Richmond Health Department.

Project Lead: Adam Hake (@adam on the CodeForRVA Slack)

## Tech Stack

Food Access Api is a built on Node, using Express.  Both the server-side and client-side code is written in CoffeeScript.  The front-end templates are written is Pug (a.k.a. Jade) with Sass handling the styling.

The database is MongoDB with Mongoose to handle the models.

Passport handles user authentication, utilizing a Local Strategy.

## Deployment

Circle CI is used for testing and continuous integration.  Pushing to the master branch will run the tests on CircleCI, and will deploy to the staging site if the test pass.  Pushing to the production branch will do the same, but deploy to the production site.

## Hosting

The site is hosted on Heroku.
