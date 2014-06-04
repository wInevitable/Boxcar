class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @method, @class, @action = pattern, http_method, 
                                          controller_class, action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)

    @method == req.request_method.downcase.to_sym && @pattern.match(req.path)
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    #@action = :index
    #@method = :get
    #@pattern = /^\/users$/
    #@class = DummyController
    
    @params = req.path
    #route_params = @params
    ControllerBase.new(req, res, @params).invoke_action(@method, @pattern, @class, @action)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
  end

  # make each of these methods that
  # when called add route
  #each adds a Route object to @routes
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      #pattern should be a regexp - user ^ and $ to match beginning/end
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    request = req
    @routes.each do |route|
      return route if route.matches?(request)
    end
  end

  # either throw 404 or call run on a matched route
  #figure out what URL was requested, match to the URL regex on one Route object
  #ask that Route to instantiate the appropriate controller
  #and call appropriate method
  def run(req, res)
  end
end
