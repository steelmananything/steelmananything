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
        results << "<details id=\"referencesDetails\">\n"
        results << "<summary>#{link_lines.size} references</summary>\n"
        results << "<ol>\n"
        link_lines.each do |line|
          shortref = line[1..line.index("]")]
          shortrefid = shortref.gsub(/[^a-zA-Z0-9]/, "")
          line = line[line.index("'")+1..].strip.chomp("'")
          if !line.index("&#013;&#013;").nil?
            last = line.rindex("&#013;&#013;")
            line = line[last+12..-1] + "\n\n" + line[0..last-1]
            line = line.gsub("&#013;", "\n")
          end
          results << "<li id=\"reference_#{shortrefid}\">#{Rinku.auto_link(Kramdown::Document.new(line, input: 'GFM').to_html, mode=:all, link_attr=nil, skip_tags=nil)}</li>\n"
        end
        results << "</ol>\n"
        results << "</details>\n"
      end
      return results
    end
  end
end

Liquid::Template.register_tag('render_references', Jekyll::ReferencesTag)
