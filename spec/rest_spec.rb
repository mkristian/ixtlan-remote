require 'ixtlan/remote/sync'
require 'ixtlan/remote/rest'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'webmock/minitest'

class Admin
  include DataMapper::Resource

  property :id, Serial
  property :name, String
end
DataMapper.setup(:default, "sqlite::memory:")
Admin.auto_migrate!

describe Ixtlan::Remote::Rest do
  subject do
    factory = Ixtlan::Remote::Rest.new
    factory.server( :users ) do |s|
      s.url = baseurl
      s.add_model( Admin )
    end
    factory
  end

  let( :baseurl ) { 'http://www.example.com' }
  let( :headers ) { { 'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby' } }
  let( :url ) { baseurl + "/admins" }
  let( :stub_get ) { stub_request(:get, url ).with(:headers => headers ) }
  let( :stub_get432 ) { stub_request(:get, url + "/432" ).with(:headers => headers ) }
  let( :stub_post ) { stub_request(:post, url ) }
  let( :stub_put ) { stub_request(:put, url + "/1" ) }
  let( :stub_delete ) { stub_request(:put, url + "/1" ) }

  [ Admin, :admins, 'admins' ].each do |admin|
    it 'retrieve collection' do
      stub_get.to_return(:status => 200, :body => '[ {"id": 123, "name": "bla" } ]', :headers => {})

      a = subject.retrieve( admin ).first

      a.new?.must_equal true
      a.id.must_equal 123
      a.name.must_equal 'bla'
    end
  end

  [ [ Admin, 432 ], [ :admins, 432 ], [ 'admins', 432 ] ].each do |admin|
    it 'retrieve entity' do
      stub_get432.to_return(:status => 200, :body => '[ {"id": 123, "name": "bla" } ]', :headers => {})

      a = subject.retrieve( *admin ).first

      a.new?.must_equal true
      a.id.must_equal 123
      a.name.must_equal 'bla'
    end
  end

  [ Admin.new( :name => 'something' ), [ Admin, { :name => 'something' } ], [ :admins, { :name => 'something' } ], [ 'admins', { :name => 'something' } ] ].each do |admin|
    it 'create' do
      stub_post
        .with( :body => "{\"name\":\"something\"}", :headers => headers )
        .to_return( :status => 200, :body => '{"id": 111, "name": "bla" }' )
     
      a = subject.create( *admin )

      a.new?.must_equal true
      a.id.must_equal 111
      a.name.must_equal 'bla'
    end
  end

  [ Admin.new( :id => 1, :name => 'something' ), [ Admin, 1, { :id => 1, :name => 'something' } ], [ :admins, 1, { :id => 1, :name => 'something' } ], [ 'admins', 1, { :id => 1, :name => 'something' } ] ].each do |admin|
    it 'update' do
      stub_put
        .with( :body => "{\"id\":1,\"name\":\"something\"}", :headers => headers )
        .to_return( :status => 200, :body => '{"id": 111, "name": "bla" }' )
     
      a = subject.update( *admin )

      a.new?.must_equal true
      a.id.must_equal 111
      a.name.must_equal 'bla'
    end
  end

  [ Admin.new( :id => 1, :name => 'something' ), [ Admin, 1, { :id => 1, :name => 'something' } ], [ :admins, 1, { :id => 1, :name => 'something' } ], [ 'admins', 1, { :id => 1, :name => 'something' } ] ].each do |admin|
    it 'delete' do
      stub_delete
        .with( :body => "{\"id\":1,\"name\":\"something\"}", :headers => headers )
        .to_return( :status => 200 )
     
      a = subject.update( *admin )

      a.must_be_nil
    end
  end

end
