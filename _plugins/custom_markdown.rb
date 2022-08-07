require 'kramdown-parser-gfm'

class CustomMarkdownParser < Kramdown::Parser::GFM
  # This just happens to be a method called after
  # parsing is pretty much complete, so use it
  # as a hook to modify the tree
  def correct_abbreviations_attributes
    super

    # First we have to process @link_defs to convert the link IDs
    # to the anchor-style references we'll search for
    processed_link_defs = {}
    @link_defs.each do |key, link_def|
      processed_link_defs[Jekyll::ReferencesTag.remove_invalid_anchor_characters(key)] = link_def
    end

    process_element(@root, processed_link_defs)
  end

  def process_element(element, processed_link_defs)
    element.children.each do |child|
      if child.type == :a
        href = child.attr["href"]
        if !href.nil? && href.length > 0 && href[0] == '#'
          href = href[1..-1]
          link_def = processed_link_defs[href.downcase]
          if !link_def.nil?
            title = ""
            if link_def.size >= 2
              title = link_def[1]
            else
              title = link_def[0]
            end
            child.attr["title"] = title
          else
            # If it has a year, then it's a citation so warn that it's missing a linkdef
            if /[12][0-9][0-9][0-9]/.match?(href)
              puts "Warning: Could not find matching link definition for #{child.attr["href"]}"
            end
          end
        end
      else
        process_element(child, processed_link_defs)
      end
    end
  end
end

class CustomHtmlConverter < Kramdown::Converter::Html
  # So far we just have customizations in the parser, but
  # in case we ever need to customize the converter...
end

module Kramdown
  # Modified based on lib/jekyll/converters/markdown/kramdown_parser.rb
  class JekyllDocument < Document
    class << self
      attr_reader :options, :parser

      def setup(options)
        @cache ||= {}
        unless @cache[:id] == options.hash
          @options = @parser = nil
          @cache[:id] = options.hash
        end
        @options ||= Options.merge(options).freeze
        @parser  ||= CustomMarkdownParser
      end
    end

    def initialize(source, options = {})
      JekyllDocument.setup(options)
      @options = JekyllDocument.options
      @root, @warnings = JekyllDocument.parser.parse(source, @options)
    end

    def to_html
      output, warnings = CustomHtmlConverter.convert(@root, @options)
      @warnings.concat(warnings)
      output
    end
  end
end

class Jekyll::Converters::Markdown::CustomKramdownParser < Jekyll::Converters::Markdown::KramdownParser
  def initialize(config)
    super(config)
  end

  def convert(content)
    document = Kramdown::JekyllDocument.new(content, @config)
    html_output = document.to_html
    if @config["show_warnings"]
      document.warnings.each do |warning|
        Jekyll.logger.warn "Kramdown warning:", warning
      end
    end
    html_output
  end
end

class Jekyll::Converters::Markdown::CustomMarkdown
  def initialize(config)
    @config = config
  end

  def convert(content)
    Jekyll::Converters::Markdown::CustomKramdownParser.new(@config).convert(content)
  end
end
