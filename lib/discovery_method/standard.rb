module DiscoveryMethod
  class Standard
#    SELECTOR_REGEX = /^http(s)?:\/\//
    SELECTOR_REGEX = //

    def initialize(doc)
      @doc = doc
    end

    def discover_name
      discover_name_from_meta_tag || discover_name_from_title_tag
    end

    def discover_name_from_meta_tag
      tag = (@doc/"meta[@name=title]").first
      tag.get_attribute('content') if tag
    end

    def discover_name_from_title_tag
      tag = (@doc/"head title").first
      tag.innerText if tag
    end

    def discover_description
      tag = (@doc/"meta[@name=description]").first
      tag.get_attribute('content') if tag
    end

    def discover_thumbnail
      tag = (@doc/"link[@rel=image_src]").first
      thumbnail = tag.get_attribute('href') if tag
      @discovered_thumbnail = (thumbnail && @discoverer.valid_uri_scheme?(thumbnail) ? thumbnail : nil)
    end
  end
end

DiscoveryParser::HTML::DISCOVERY_METHODS << DiscoveryMethod::Standard
