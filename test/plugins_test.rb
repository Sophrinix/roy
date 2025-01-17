require_relative 'helper'
require 'roy/plugins'
require 'roy/before'
require 'roy/after'

class PluginsTestObject
  include Roy
  include Roy::Plugins(Before, After)

  roy allow: [:get],
      before: lambda { |env|
        env['REQUEST_METHOD'] = 'GET'
      },
      after: lambda { |response|
        response.header['Content-Type'] = 'text/plain'
      }

  def get(*args)
    'success'
  end
end

class PluginsTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    PluginsTestObject.new
  end

  def test_plugins_are_loaded
    get '/'
    ok!
    assert_equal 'text/plain', last_response.header['Content-Type']
    assert_equal 'success', last_response.body
  end

end
