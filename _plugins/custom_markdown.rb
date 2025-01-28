require 'kramdown-parser-gfm'

class CustomMarkdownParser < Kramdown::Parser::GFM

  DEBUG = ENV["DEBUG"] == "true"

  # This just happens to be a method called after
  # parsing is pretty much complete, so use it
  # as a hook to modify the tree
  def correct_abbreviations_attributes
    super

    # First we have to process @link_defs to convert the link IDs
    # to the anchor-style references we'll search for
    processed_link_defs = {}
    if DEBUG
      puts "Link defs: #{@link_defs.inspect}"
    end
    @link_defs.each do |key, link_def|
      putkey = Jekyll::ReferencesTag.remove_invalid_anchor_characters(key)
      if DEBUG
        puts "Put #{putkey} = #{link_def[0]}"
      end
      processed_link_defs[putkey] = link_def
    end

    process_element(@root, processed_link_defs)
  end

  def process_element(element, processed_link_defs)
    element.children.each do |child|
      if child.type == :a
        href = child.attr["href"]
        if !href.nil? && href.length > 0 && href[0] == '#'
          href = href[1..-1]
          checkkey = href.downcase
          if DEBUG
            puts "Checking key #{checkkey}"
          end
          link_def = processed_link_defs[checkkey]
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
              if DEBUG
                puts "Could not find key #{checkkey}"
              end
              warning("Warning: Could not find matching link definition for #{child.attr["href"]}")
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
      @@last_source = source
      #if !source.nil?
      #  debuginfo = source.to_s
      #  if debuginfo.length > 50
      #    debuginfo = debuginfo[0..50] + "..."
      #  end
      #  puts "Processing #{debuginfo}"
      #end
      JekyllDocument.setup(options)
      @options = JekyllDocument.options
      @root, @warnings = JekyllDocument.parser.parse(source, @options)
    end

    def to_html
      output, warnings = CustomHtmlConverter.convert(@root, @options)
      @warnings.concat(warnings)
      output
    end

    def self.getLastSource
      return @@last_source
    end
  end
end

class Jekyll::Converters::Markdown::CustomKramdownParser < Jekyll::Converters::Markdown::KramdownParser
  @@first_warning = true

  def initialize(config)
    super(config)
  end

  def convert(content)
    document = Kramdown::JekyllDocument.new(content, @config)
    html_output = document.to_html
    #if @config["show_warnings"]
    if true
      document.warnings.each do |warning|
        if @@first_warning && warning.include?("Could not find matching link definition")
          Jekyll.logger.warn "First Kramdown warning: there appear to be two passes over the markdown, so 'Could not find matching link definition' warnings may be expected"
          @@first_warning = false
        end
        last_source = Kramdown::JekyllDocument.getLastSource
        if !last_source.nil?
          last_source = last_source.to_s
          if last_source.length > 50
            last_source = last_source[0..50] + "..."
          end
          Jekyll.logger.warn "In: #{last_source}"
        end
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
