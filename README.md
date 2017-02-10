# README

## Description

I think I got carried away writing it, so almost ended up with an Argo competitor written :smiley:

Here's what I implemented:   
- token auth via `devise_token_auth`
- specs (e2e, model, functional and views)
- `destroy` actions
- rewired the code to work inside the new Rails API app
- refactored current error handling globally in `ApplicationController` for common code. Specific errors can be still handled in old way via controller actions. Also as app matures API frameworks are often considered, that depends a lot on context, in my opinion.
- token auth is just ensuring that user only has access to his own entities. In case more advanced authentication is required, I suggest using `cancancan` for sharing resources and ensuring nested resources belong to parent (I can't see the latter functionality needed in this app though)
- I skipped some E2E tests for bank guarantees, cause it's essentially the same as transactions controller, so I decided not to write similar actions there for the purpose of this test, hope that's okay

## Some notes about the code and decisions:
- controller specs are for functional testing
- view tests are written this way, because they help ensure that JSON format and attributes are correct, and that we don't render sensitive data (as project grows, there is an option to use `ActiveModelSerializer` gem for that purpose)
- request specs are for e2e testing. Just controller specs might be enough (depends on team preference and velocity), but I wanted to lay a foundation cause it's harder to start writing e2e tests later when some uncovered functionality is already present.
ALSO they ensure e2e integration here (including views rendering - that's what controller specs don't do, and in case future features add some Rack middlewares or different ways of rendering views (gems like `grape` or `ActiveModelSerializer`, or decorators) they will come in handy)
- called user model `Company`, might be `User` as well, but in case other user types come in - we can be prepared
- devise auth is not refreshing tokens on each request, I disabled that on purpose for easier testing.
- you can't register a user from API, I would expect some other micro-service app handling that, or it can be written as an API endpoint here - I can do that if you want, but since it's quite straightforward I decided to focus on other things

## Installation
`bundle install`   
`bundle exec rake db{:create,migrate}`   
`bundle exec rspec`   
`bundle exec rails c`   
in console:    
`Company.create(email: "test@example.com", password: "testtest", confirmed_at: Time.now)`   
Start a server:   
`bundle exec rails s`

Sample requests flow (please change `access-token` and `client` for ones generated in first command. Unfortunately that's the inconvenience with `curl` testing):
```
curl -i -X POST -d "email=test@example.com&password=testtest" http://0.0.0.0:3000/api/v1/auth/sign_in

curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "access-token: TcXtY0QGojRE_XA0cJzaQg" -H "client: ihA8Plox6vQBypnD_c5r2g" -H "uid: test@example.com" -X POST -d '{"transaction":{"name":"test transaction"}}'  http://0.0.0.0:3000/api/v1/transactions 
# => {"id":2,"name":"test transaction","created_at":"2017-02-10T18:10:23.174Z"}

curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "access-token: TcXtY0QGojRE_XA0cJzaQg" -H "client: ihA8Plox6vQBypnD_c5r2g" -H "uid: test@example.com" -X POST -d '{"transaction":{"namezz":"test transaction"}}'  http://0.0.0.0:3000/api/v1/transactions 
# => {"name":["can't be blank"]}

curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "access-token: TcXtY0QGojRE_XA0cJzaQg" -H "client: ihA8Plox6vQBypnD_c5r2g" -H "uid: test@example.com" -X DELETE http://0.0.0.0:3000/api/v1/transactions/11 
# => {"error":"Couldn't find Transaction with 'id'=11 [WHERE \"transactions\".\"company_id\" = ?]"}

curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "access-token: TcXtY0QGojRE_XA0cJzaQg" -H "client: ihA8Plox6vQBypnD_c5r2g" -H "uid: test@example.com" -X DELETE http://0.0.0.0:3000/api/v1/transactions/2 # => 204 no content

curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "access-token: TcXtY0QGojRE_XA0cJzaQg" -H "client: ihA8Plox6vQBypnD_c5r2g" -H "uid: test@example.com" -X POST -d '{"bank_guarantee":{"active":"true", "transaction_id": "3"}}'  http://0.0.0.0:3000/api/v1/transactions/2/bank_guarantees/ 
# => 422 {"current_transaction":["must exist"]}

curl -v -H "Accept: application/json" -H "Content-type: application/json" -H "access-token: TcXtY0QGojRE_XA0cJzaQg" -H "client: ihA8Plox6vQBypnD_c5r2g" -H "uid: test@example.com" -X POST -d '{"bank_guarantee":{"active":"true", "transaction_id": "1"}}'  http://0.0.0.0:3000/api/v1/transactions/2/bank_guarantees/ 
# => 201 CREATED {"id":1,"transaction_id":1,"created_at":"2017-02-10T18:14:07.170Z"}
```

Best,
Sergey