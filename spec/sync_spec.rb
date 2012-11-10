require 'ixtlan/remote/sync'
require 'ixtlan/remote/rest'
require 'dm-aggregates'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'webmock/minitest'

class Locale
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :updated_at, DateTime
end
DataMapper.setup(:default, "sqlite::memory:")
Locale.auto_migrate!

describe Ixtlan::Remote::Sync do

  subject do
    s = Ixtlan::Remote::Sync.new( restserver)
    s.register( Locale )
    s
  end

  let( :baseurl ) { 'http://www.example.com' }
  let( :restserver ) do
    factory = Ixtlan::Remote::Rest.new
    factory.server( :trans ) do |s|
      s.url = baseurl
      s.add_model( Locale )
    end
    factory
  end
  let( :headers ) { { 'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby' } }
  let( :url ) { baseurl + "/locales" }

  before { Locale.all.destroy }

  it 'sync all' do

    stub_request(:get, /#{url}\/last_changes.*00:00:00.*/)
      .with(:headers => headers)
      .to_return( :status => 200, :body => '[{"id": 111, "name": "bla", "updated_at":"2011-07-20 11:11:11.000000+0:00" }]' )
    
    subject.do_it.to_s.must_equal "update Locale - total: 1  success: 1  failures: 0"
    
    Locale.count.must_equal 1

    stub_request(:get, /#{url}\/last_changes.*11:11:11.*/)
      .with(:headers => headers)
      .to_return( :status => 200, :body => '[{"id": 111, "name": "blabla", "updated_at":"2011-07-20 11:11:12.000000+0:00" }]' )
    
    subject.do_it( Locale ).to_s.must_equal "update Locale - total: 1  success: 1  failures: 0"
    
    Locale.count.must_equal 1
    Locale.first.name.must_equal 'blabla'

    stub_request(:get, /#{url}\/last_changes.*11:11:12.*/)
      .with(:headers => headers)
      .to_return( :status => 200, :body => '[]' )
    
    subject.do_it.to_s.must_equal "update Locale - total: 0  success: 0  failures: 0"
 
    Locale.count.must_equal 1
  end
 
  it 'sync Locale' do

    stub_request(:get, /#{url}\/last_changes.*00:00:00.*/)
      .with(:headers => headers)
      .to_return( :status => 200, :body => '[{"id": 111, "name": "bla", "updated_at":"2011-07-20 10:10:10.000000+0:00" }]' )
    
    subject.do_it( Locale ).to_s.must_equal "update Locale - total: 1  success: 1  failures: 0"
    
    Locale.count.must_equal 1

    stub_request(:get, /#{url}\/last_changes.*10:10:10.*/)
      .with(:headers => headers)
      .to_return( :status => 200, :body => '[{"id": 111, "name": "blabla", "updated_at":"2011-07-20 10:10:11.000000+0:00" }]' )
    
    subject.do_it( Locale ).to_s.must_equal "update Locale - total: 1  success: 1  failures: 0"
    
    Locale.count.must_equal 1
    Locale.first.name.must_equal 'blabla'

    stub_request(:get, /#{url}\/last_changes.*10:10:11.*/)
      .with(:headers => headers)
      .to_return( :status => 200, :body => '[]' )
    
    subject.do_it( Locale ).to_s.must_equal "update Locale - total: 0  success: 0  failures: 0"
 
    Locale.count.must_equal 1
  end
end
