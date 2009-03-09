require 'rubygems'
require 'hpricot'
require File.dirname(__FILE__) + '/../lib/discoverer'

describe DiscoveryMethod::Standard do
  it "should match anything" do
    DiscoveryMethod::Standard::SELECTOR_REGEX.should match("anything")
  end
end
