module Rack
  module Helpers
    def should_not_alter_request_and_response(env)
      # To make recursive copy; dup copies only 1-st level variables 
      env_clone=JSON::parse(JSON::dump(env))
      response=Response.new ['Random text'], 2000, {:random=>'Hash'}
      app=mock('app')
      app.should_receive(:call).with(env_clone).and_return(response.finish)
      result=Encryption.new(app).call(env_clone)
      result.should == response.finish
      env_clone.should == env
    end

    def time_to_sql_format(time)
      #Data format for mysql 2012-12-28 14:03:27      
      "('"+time.utc.strftime("%Y-%m-%d %H:%M:%S")+"')"
    end

  end
end

