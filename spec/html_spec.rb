require 'rubygems'
require 'hpricot'
require File.dirname(__FILE__) + '/../lib/discoverer'

describe DiscoveryParser::HTML do
  def local_file(file)
     mock('index.html', 
      :url => 'index.html',
      :uri => URI.parse('file:///index.html'), 
      :response => mock('response', :body => open("spec/fixtures/#{file}.html", "r").read))
  end

  it "should contain 1 Discovery Method" do
    ::DiscoveryParser::HTML::DISCOVERY_METHODS.should have_at_least(1).items
  end

  it "should contain the Standard Discovery Method by default" do
    parser = DiscoveryParser::HTML.new(local_file('name_from_title_tag'))
    parser.send(:select_discovery_method).should be(DiscoveryMethod::Standard)
  end

  it "should get the name from the title tag" do
    parser = DiscoveryParser::HTML.new(local_file('name_from_title_tag'))
    parser.parse
    parser.name.should == "title from title tag"
  end

  it "should get the name from the meta tag" do
    parser = DiscoveryParser::HTML.new(local_file('name_from_meta_tag'))
    parser.parse
    parser.name.should == "title from meta tag"
  end

  it "should get the description from the meta tag" do
    parser = DiscoveryParser::HTML.new(local_file('description_from_meta_tag'))
    parser.parse
    parser.description.should == "description from meta tag"
  end
end
