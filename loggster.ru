class Loggster
	def initialize app
    @app = app
  end

  def call env
    start_time = Time.now
    status, headers, body = @app.call env
    end_time = Time.now

    Dir.mkdir('logs') unless File.directory?('logs')
    File.open('logs/server.log', 'a+') do |f|
      f.write("[#{Time.now}] \"#{env['REQUEST_METHOD']} #{env['PATH_INFO']}\" #{status} Delta: #{end_time - start_time}s \n")
    end

    [status, headers, body]
  end
end

class RackApp
	def self.call(env)
		[200, {'Content-Type' => 'text/html'}, ['Hi!']]
	end
end

use Loggster
run RackApp