require_relative 'router/route'

module Simpler
  class Router
    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']
      env['simpler.params'] ||= {}

      if contain_ids?(path)
        params_id = path.scan(/\d+/)[0].to_i
        env['simpler.params'].merge!(id: params_id)

        path.gsub!(/\d+/, ":id")
      end

      @routes.find { |route| route.match?(method, path) }
    end

    private

    def contain_ids?(path)
      path.scan(/\d+/).any?
    end

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end
  end
end
