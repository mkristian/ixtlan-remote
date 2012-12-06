ixtlan-remote
-------------

* [![Build Status](https://secure.travis-ci.org/mkristian/ixtlan-remote.png)](http://travis-ci.org/mkristian/ixtlan-remote)
* [![Dependency Status](https://gemnasium.com/mkristian/ixtlan-remote.png)](https://gemnasium.com/mkristian/ixtlan-remote)
* [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mkristian/ixtlan-remote)

the idea is to register the remote rest(ful) servers at one place and then just talk to a rest-manager to make a rest http request.

for example configure the 'users' server like this

     rest = Ixtlan::Remote::Rest.new
     rest.server( :users ) do |s|
        s.url = 'http://example.com/rest'
        s.add_model( Admin )
        s.add_model( Account, "path/to/accounts" )
        s.add_model( Locale )
     end

now you can do something like this:

    a = rest.create( Admin.new( :id => 1, :name => 'me and the corner' ) ) # #<Admin @id=1 @name="me and the corner">
    rest.retrieve( Admin, 1 )                                              # #<Admin @id=1 @name="me and the corner">
    a.name = 'me'
    rest.update( a )                                                       # #<Admin @id=1 @name="me">
    rest.delete( a )

or the same with less magic

    a = rest.create( :admins, { :id => 1, :name => 'me and the corner' } # #<Admin @id=1 @name="me and the corner">
    rest.retrieve( :admins )                                             # [#<Admin @id=1 @name="me and the corner">]
    rest.update( :admins, 1, { :id => 1, :name => 'me' } )               # #<Admin @id=1 @name="me">
    rest.delete( :admins, 1 )

where the last argument is the payload and the first argument is the model (either Class, String or Symbol). the rest will be joined as "path" and appended to the baseurl of the model.

the instantiation of the model objects (Admin, Account, etc) works either with passng in the attributes into the constructor (Admin.new( attributes ), etc) or with DataMapper it will try to load the object first from the datastore and then updates its attributes (no save only update on local object).

sync
----

possible setting: there are loosely coupled miniapps which share data between them but only one miniapp can modify that data. i.e. one app manages users/groups and their authentication, another app allows to translate the i18n of apps and manages the list of allowed locales, etc. so let's say there are user data (a subset of the users-app user) and locale data which are needed in an app then you can sync them lke this:

     sync = Ixtlan::Remote::Sync.new( rest )
     sync.register( Locale )

     sync.do_it # i.e. "update Locale - total: 1  success: 1  failures: 0"

that `sync.do_it` can run in a cronjob and your data gets easily syncronized between miniapps. one could call it a master-slave setup for quasi static data. quasi static like users or locales or venue locations or list of countries etc. quasi static since you sync with a cronjob maybe running once a day or maybe each hour. for volatile data you better use the remote server directly, i.e. for authentication.
    
Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

meta-fu
-------

enjoy :) 

