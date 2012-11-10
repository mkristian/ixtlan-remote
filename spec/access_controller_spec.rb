require 'dm-sqlite-adapter'
require 'dm-migrations'
require 'ixtlan/remote/permission'
require 'ixtlan/remote/access_controller'

DataMapper.setup(:default, 'sqlite::memory:')
Ixtlan::Remote::Permission.auto_migrate!
Ixtlan::Remote::Permission.create(:ip => '1.1.1.1', :token => 'behappy')
Ixtlan::Remote::Permission.create(:token => 'be happy')

class Controller
  include Ixtlan::Remote::AccessController
  
  def new_request
    r = Object.new
    def r.headers
      @m ||= {}
        end
    def r.remote_ip(p = nil)
      @i = p if p
      @i
    end
    r
  end
  def request
    @r ||= new_request
  end
end

describe Ixtlan::Remote::AccessController do

  subject { Controller.new }

  it 'should raise when there is no token' do
    subject.request.headers.clear

    lambda {subject.remote_permission}.must_raise RuntimeError
  end

  it 'should raise wrong authentication' do
    subject.request.headers['X-SERVICE-TOKEN'] = 'something'

    lambda {subject.remote_permission}.must_raise RuntimeError
  end

  it 'should pass without permission IP' do
    subject.request.headers['X-SERVICE-TOKEN'] = 'be happy'

    subject.remote_permission.token.must_equal 'be happy'
  end

  it 'should fail with wrong IP' do
    subject.request.headers['X-SERVICE-TOKEN'] = 'behappy'

    lambda {subject.remote_permission}.must_raise RuntimeError
  end

  it 'should pass with right IP' do
    subject.request.headers['X-SERVICE-TOKEN'] = 'behappy'
    subject.request.remote_ip '1.1.1.1'

    subject.remote_permission.token.must_equal 'behappy'
    subject.remote_permission.ip.must_equal '1.1.1.1'
  end
end
