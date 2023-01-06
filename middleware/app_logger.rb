require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    response = @app.call env
    @logger.info(write_to_log(env: env, response: response))

    response
  end

  private

  def write_to_log(env:, response:)
    <<-DOC

      Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}
      Handler: #{env['simpler.controller'].class}##{env['simpler.action']}
      Parameters: #{env['simpler.params']}
      Response: #{response[0]} [#{response[1]['Content-Type']}] #{env['simpler.template_path']}
    DOC
  end
end
