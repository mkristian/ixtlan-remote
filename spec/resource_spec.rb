require 'ixtlan/remote/resource'
require 'ixtlan/remote/server'
require 'active_support/core_ext/string'
require 'json'
class RestClientMock

  def [](path)
    @path = path
    self
  end
  
  attr_reader :path
  attr_accessor :response_payload
  
  def response_payload( *args )
    @response_payload
  end

  alias :get :response_payload
  alias :post :response_payload
  alias :put :response_payload
  alias :delete :response_payload

end
class User
  
  def initialize( args = {} )
    @id = (args || {})['id'].to_i
    @name = (args || {})['name']
  end

  attr_reader :id, :name

  def attributes
    {'id' => @id, 'name' => @name }
  end
end
class ClientUser < User; end

describe Ixtlan::Remote::Resource do

  subject {  Ixtlan::Remote::Resource.new( rest_client, User ) }
 
  let( :rest_client ) { ::RestClientMock.new }

  describe 'create' do
    [ User, :users, "users", ["admins", 1, User], ["admins/1", User], ClientUser ].each do |user|
      it 'user without root' do
        
        rest_client.response_payload = '{ "id": 1, "name": "bla" }'
        
        u = subject.create( *user, :name => 'bla' ).send_it
        u.id.must_equal 1
        u.name.must_equal 'bla'
        
        u.class.must_equal User
        rest_client.path.must_match /(.*\/)?users$/
      end
      
      it 'user with root' do
        
        rest_client.response_payload = '{ "user": { "id": 1, "name": "bla" } }'
       
        u = subject.create( *user, :name => 'bla' ).send_it
        u.id.must_equal 1
        u.name.must_equal 'bla'
        
        u.class.must_equal User
        rest_client.path.must_match /(.*\/)?users$/
      end
    end
  end

  describe 'retrieve' do
    [ User.new('id' => 1), User, :users, "users", ["admins", 1, User], ["admins/1", User], ClientUser ].each do |user|
      it 'user without root' do
        
        rest_client.response_payload = '{ "id": 1, "name": "bla" }'

        u = subject.retrieve( *user, 1 ).send_it
        u.id.must_equal 1
        u.name.must_equal 'bla'
        
        u.class.must_equal User
        rest_client.path.must_match /(.*\/)?users\/1$/
      end
      
      it 'users without root' do
        
        rest_client.response_payload = '[ { "id": 1, "name": "bla" }, { "id": 2, "name": "blabla" } ]'

        u = subject.retrieve( *user ).send_it
        u.size.must_equal 2
        u[0].id.must_equal 1
        u[0].name.must_equal 'bla'
        u[1].id.must_equal 2
        u[1].name.must_equal 'blabla'
        
        u[0].class.must_equal User
        u[1].class.must_equal User
        rest_client.path.must_match /(.*\/)?users$/
      end
   
      it 'user with root' do
        
        rest_client.response_payload = '{ "user": { "id": 1, "name": "bla" } }'

        u = subject.create( *user, 1 ).send_it
        u.id.must_equal 1
        u.name.must_equal 'bla'
        
        u.class.must_equal User
        rest_client.path.must_match /(.*\/)?users\/1$/
      end

      it 'users with root' do
        
        rest_client.response_payload = '[ { "user": { "id": 1, "name": "bla" } }, { "user": { "id": 2, "name": "blabla" } } ]'

        u = subject.create( *user ).send_it
        u.size.must_equal 2
        u[0].id.must_equal 1
        u[0].name.must_equal 'bla'
        u[1].id.must_equal 2
        u[1].name.must_equal 'blabla'
        
        u[0].class.must_equal User
        u[1].class.must_equal User
        rest_client.path.must_match /(.*\/)?users$/
      end       
    end
  end

  describe 'update' do
    [ User.new('id' => 1), User, :users, "users", ["admins", 1, User], ["admins/1", User], ClientUser ].each do |user|
      it 'user without root' do
        
        rest_client.response_payload = '{ "id": 1, "name": "bla" }'

        u = subject.update( *user, 1, :name => 'buh' ).send_it
        u.id.must_equal 1
        u.name.must_equal 'bla'
                
        u.class.must_equal User
        rest_client.path.must_match /(.*\/)?users\/1$/
      end

      it "user with root #{user} " do
        
        rest_client.response_payload = '{ "user": { "id": 1, "name": "blablabla" } }'

        u = subject.update( *user, 1, :name => 'buh' ).send_it

        u.id.must_equal 1
        u.name.must_equal 'blablabla'        
        u.class.must_equal User
        rest_client.path.must_match /(.*\/)?users\/1$/
      end
    end
  end

   describe 'delete' do
    [ [User, 1], [:users,1], ["users",1], ["admins", 1, User, 1], ["admins/1", User, 1], [ClientUser, 1] ].each do |user|
      it "user #{user.inspect}" do
        subject.delete( *user ).send_it.must_be_nil

        rest_client.path.must_match /(.*\/)?users\/1$/
      end
   end
 end
end
