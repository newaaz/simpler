require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response
    attr_accessor :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      send(action)

      set_default_headers
      set_headers

      write_response
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def set_headers
      @headers.each { |header, value| @response[header] = value }
    end

    def status(status = 200)
      @response.status = status
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge(@request.env['simpler.params'])
    end

    def render(template)
      @request.env['simpler.template'] = template
    end
  end
end
