require 'ixtlan/remote/model_helpers'
require 'active_support/core_ext/string'
describe Ixtlan::Remote::ModelHelpers do

  subject { Object.send :include, Ixtlan::Remote::ModelHelpers }

  it 'should pass through' do
    subject.to_model("asd").must_equal "asd"
    subject.to_model(:asd).must_equal :asd
  end

  it 'should get first key of hash' do
    subject.to_model(:be_happy => []).must_equal :be_happy
    subject.to_model(:be_happy => {}).must_equal :be_happy
  end

  it 'should get class' do
    subject.to_model(String).must_equal String
    subject.to_model(["dsa"]).must_equal String
    subject.to_model(Object.new).must_equal Object
  end

  it 'should get underscored string' do
    subject.to_model_underscore(StringIO).must_equal 'string_io'
    subject.to_model_underscore(["dsa"]).must_equal 'string'
    subject.to_model_underscore(Object.new).must_equal 'object'
    subject.to_model_underscore(:be_happy => []).must_equal 'be_happy'
    subject.to_model_underscore(:be_happy => {}).must_equal 'be_happy'
    subject.to_model_underscore("asd").must_equal 'asd'
    subject.to_model_underscore(:asd).must_equal 'asd'
  end

  it 'should get underscored singular' do
    subject.to_model_singular_underscore('women').must_equal 'woman'
    subject.to_model_singular_underscore(:men).must_equal 'man'
  end

end
