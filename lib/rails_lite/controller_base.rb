require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'


class ControllerBase
  attr_reader :params, :req, :res

  # setup the controller
  def initialize(req, res, route_params = {})
    @res, @req, @route_params = res, req, route_params
    @params = Params.new(req, route_params)
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    unless already_built_response?
      @res.content_type = type
      @res.body = content
      session.store_session(@res)
      @already_built_response = true
    else
      raise "double render error"      
    end
  end

  # helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ||= false
  end

  # set the response status code and header
  def redirect_to(url)
    unless already_built_response?
      @res.status = 302
      @res["location"] = url
      session.store_session(@res)
      @already_built_response = true
    else
      raise "double render error"
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    template = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    content = ERB.new(template).result(binding)

    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name, pattern, con_class, action)
    if Router.new.send(name, pattern, con_class, action)
      #pattern, controller_class, action_name
      #/^\/users$/ , DummyController , :index
    else
      render
    end
  end
end
