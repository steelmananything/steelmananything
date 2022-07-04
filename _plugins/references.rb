require 'kramdown'
require 'kramdown-parser-gfm'
require 'rinku'

module Jekyll
  class ReferencesTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @text = markup
    end

    def render(context)
      link_lines = []
      File.readlines(context['page']['path']).each do |line|
        if line.start_with?("[") && line.strip.end_with?("'")
          link_lines << line
        end
      end

      results = ""
      if link_lines.size > 0
        results << "<h2 id=\"references\">References</h2>\n"
        results << "<details>\n"
        results << "<summary>#{link_lines.size} references</summary>\n"
        results << "<ol>\n"
        link_lines.each do |line|
          line = line[line.index("'")+1..].strip.chomp("'")
          results << "<li>#{Rinku.auto_link(Kramdown::Document.new(line, input: 'GFM').to_html, mode=:all, link_attr=nil, skip_tags=nil)}</li>\n"
        end
        results << "</ol>\n"
        results << "</details>\n"
      end
      return results
    end
  end
end

Liquid::Template.register_tag('render_references', Jekyll::ReferencesTag)
