To see the README for original project skeleton from App Academy, please
scroll down to the bottom of this README.

------

Each file in the ./bin folder tests a different phase of implementation for
RailsLite. The behavior of each phase is document below.

#### [Phase 1:](./bin/p01_basic_server.rb)
  Create WEBrick::HTTPServer to listen to requests as port 3000. Add in trap
  method to allow for interrupting server.

  WEBrick::HTTPServer#mount_proc("/") will mount a proc at the root URL. All
  requests mades to subdirectories without a proc mounted will fall here. New
  WEBrick::HTTPResponse/Request objects are made and passed into the block.

  Response object manually changed in proc. Content type and body defined,
  and response is sent back to client.

#### [Phase 2:](./bin/p02_controller_server.rb)
  A Controller object that extends ControllerBase is instantiated in proc.
  Controller take takes the Request and Response objects and saves them as
  instance variables and a boolean set to to false initially.

  If the request comes in form the '/cats' path, ControllerBase#render_content
  is called. This sets the boolean instance variable to true (so as to not
  build more the response more than once), sets the response's body and content
  type to the arguments passed into it. When the proc finishes, the response
  is sent back to the client with the new body and content.

  When a request comes to a different path, ControllerBase#redirect_to is
  called. It sets the response's status to 302 (Found), and the response's
  location to the redirect URL (and changes the saved boolean to true). The
  client then receives the response with the redirect.

#### [Phase 3:](./bin/p03_template_server.rb)
  Controller object is created and called ControllerBase#render. This method
  reads the corresponding file for the name of the template passed into it
  by looking at its own name and creating the file path.

  An ERB object is then created with the text for parsing. ERB#result is then
  called for the results, and the argument is "binding". Binding is a method
  that sets the scope for variables. In this case, it sets the scope to the
  Controller object's scope. This results in an HTML template with the ERB
  components translated into HTML using variables at the scope of the level
  of the controller.

  ControllerBase#render_content is then called with this new HTML template and
  the content type being 'text/html'.

  As before, #render_content sets the values necessary in the response and
  the final response is sent to the client as an HTML document to render.

#### [Phase 4:](./bin/p04_session_server.rb)
  Controller object calls it's #go method which then calls
  ControllerBase#session. This method returns a session (which is created
  if one is not already saved in an instance variable). Session objects
  take a request as an argument and extract the cookie from the request. If a
  cookie for the corresponding website is not yet in the request, a new one is
  made. The controller then modifies the session, which in turn modifies the
  value of the cookie. It then renders a ERB template that shows the value of
  the cookie, which is automatically parsed by an ERB object into HTML.

  The #render_content method is then called to put the HTML document in the
  response. The response is then returned to the client.

#### [Phase 5:](./bin/p05_params_server.rb)
  The body of #mount_proc now acts as a "router" for cats by creating a new
  CatController for selected requests to the /cats routes. The controller
  now also takes route parameters manually inserted in.

  The controller then creates a Params object with the request and route
  parameters. The Params object parses the request's query string and body
  to create appropriately nested hashes and merges those two together with
  the route parameters hash. Methods in the CatController object can now
  access parameters via a hash like object called Params.

  The Cat object is an object that imitates the behavior of an ActiveRecord
  class while the server is running.

#### [Phase 6:](./bin/p06_router_server)
  A new Router object is created to direct a request to the proper controller
  and action. The routes are "drawn" with the Router#draw method and the router
  then simply runs the request with #run(req,res).

  The router goes through its collection of Route objects to find a match using
  the request's path and request_method to compare to its own routes. If a
  suitable route object is not found, it changes the requests default 200 (OK)
  status to 404 (Not Found) and the request is returned. If a route is found,
  then the router invokes the route's own #run method.

  In the route, the run method parses the path string to make a hash of
  path parameters, creates its controller object, and tells the controller
  to call its action. The rest of the implementation has already been complete
  at this point and the controller is able to call params, session, and create
  appropriate responses!


--------------
Original README:
--------------

# w5d2: [Rails Lite!][description]

## Using The Specs

Some specs have been written to guide you towards the lite. There are
rspec specs in the `spec` directory and demo servers for you to try
in the `bin` directory.

## Suggested Order

0.  `bundle exec rspec spec/p02_controller_spec.rb`
0.  `bundle exec rspec spec/p03_template_spec.rb`
0.  `bundle exec rspec spec/p04_session_spec.rb`
0.  `bundle exec rspec spec/p05_params_spec.rb`
0.  `bundle exec rspec spec/p06_router_spec.rb`
0.  `bundle exec rspec spec/p07_integration_spec.rb`

Run `bundle exec rspec` to run all the spec files.

[description]: https://github.com/appacademy/rails-curriculum/blob/master/projects/w5d2-rails-lite-i.md
