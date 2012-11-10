require 'ixtlan/remote/sync'
require 'ixtlan/remote/rest'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'webmock/minitest'

class Name
  include DataMapper::Resource

  property :id, Serial
  property :name, String
end
DataMapper.setup(:default, "sqlite::memory:")
Name.auto_migrate!

describe Ixtlan::Remote::Sync do

  subject do
    s = Sync.new( restserver)
    s.register( Name )
  end

  let( :baseurl ) { 'http://www.example.com' }
  let( :restserver ) do
    factory = Ixtlan::Remote::Rest.new
    factory.server( :trans ) do |s|
      s.url = baseurl
      s.add_model( Name )
    end
    factory
  end
  let( :headers ) { { 'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby' } }
  let( :url ) { baseurl + "/names" }
  let( :stub_get ) { stub_request(:get, url ).with(:headers => headers ) }
  let( :stub_get432 ) { stub_request(:get, url + "/432" ).with(:headers => headers ) }
  let( :stub_post ) { stub_request(:post, url ) }
  let( :stub_put ) { stub_request(:put, url + "/1" ) }
  let( :stub_delete ) { stub_request(:put, url + "/1" ) }


  [ Name.new( :name => 'something' ), [ Name, { :name => 'something' } ], [ :names, { :name => 'something' } ], [ 'names', { :name => 'something' } ] ].each do |name|
    it 'create' do
      stub_post
        .with( :body => "{\"name\":\"something\"}", :headers => headers )
        .to_return( :status => 200, :body => '{"id": 111, "name": "bla" }' )
     
      a = restserver.create( *name )

      a.new?.must_equal true
      a.id.must_equal 111
      a.name.must_equal 'bla'
    end
  end

  [ Name.new( :id => 1, :name => 'something' ), [ Name, 1, { :id => 1, :name => 'something' } ], [ :names, 1, { :id => 1, :name => 'something' } ], [ 'names', 1, { :id => 1, :name => 'something' } ] ].each do |name|
    it 'update' do
      stub_put
        .with( :body => "{\"id\":1,\"name\":\"something\"}", :headers => headers )
        .to_return( :status => 200, :body => '{"id": 111, "name": "bla" }' )
     
      a = restserver.update( *name )

      a.new?.must_equal true
      a.id.must_equal 111
      a.name.must_equal 'bla'
    end
  end

  [ Name.new( :id => 1, :name => 'something' ), [ Name, 1, { :id => 1, :name => 'something' } ], [ :names, 1, { :id => 1, :name => 'something' } ], [ 'names', 1, { :id => 1, :name => 'something' } ] ].each do |name|
    it 'delete' do
      stub_delete
        .with( :body => "{\"id\":1,\"name\":\"something\"}", :headers => headers )
        .to_return( :status => 200 )
     
      a = restserver.update( *name )

      a.must_be_nil
    end
  end

end
