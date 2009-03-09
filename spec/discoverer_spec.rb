require 'rubygems'
require 'hpricot'
require File.dirname(__FILE__) + '/../lib/discoverer'

describe Discoverer do
  def local_file
    File.dirname(__FILE__) + "/fixtures/title_tag.html"
  end
  
  it "should load a html page on the filesystem" do
    discoverer = Discoverer.new(local_file)
    discoverer.stub!(:valid_uri_scheme?).with(local_file).and_return(true)
    discoverer.stub!(:load_site).and_return mock('local_file', :content_type => "text/html", :body => open("spec/fixtures/name_from_title_tag.html", "r").read)
    discoverer.filter.should be_true
    discoverer.assign_defaults

    discoverer.name.should == "title from title tag"
  end
end
