require 'kramdown'
require 'kramdown-parser-gfm'
require 'anchored'

module Jekyll
  class ReferencesTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @text = markup
    end

    def self.remove_invalid_anchor_characters(str)
      # https://stackoverflow.com/a/2849800
      # "you can use !, $, &, ', (, ), *, +, ,, ;, =, something matching %[0-9a-fA-F]{2}, something matching [a-zA-Z0-9], -, ., _, ~, :, @, /, and ?"
      str.gsub(/ /, "_").gsub(/[^a-zA-Z0-9\.,_\-\&']/, "")
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
        results << "<details id=\"referencesDetails\" open>\n"
        results << "<summary>#{link_lines.size} references</summary>\n"
        results << "<ol>\n"
        link_lines.each do |line|
          shortref = line[1..line.index("]")]
          mainlink = line[line.index("]: ")+3..]
          mainlink = mainlink[0..mainlink.index("'")-2]
          line = line[line.index("'", line.index("]: "))+1..].strip.chomp("'")
          if !line.index("&#013;&#013;").nil?
            last = line.rindex("&#013;&#013;")
            line = line[0..last-1] + "\n\n&nbsp;\n\n" + line[last+12..-1]
            line = line.gsub("&#013;", "\n")
          end

          shortrefid = Jekyll::ReferencesTag.remove_invalid_anchor_characters(shortref)

          finallink = nil
          if !line.index(". http").nil?
            finallink = line[line.index(". http")+2..]
            line = line[0..line.index(". http")+1]
          elsif !line.index(" from http").nil?
            finallink = line[line.index(" from http")+6..]
            line = line[0..line.index(" from http")+5]
          end
          if !finallink.nil? && finallink.start_with?("https://doi.org")
            doi = finallink[finallink.index("doi.org/")+8..]
            line = line + " DOI: " + doi + "."
          elsif mainlink.start_with?("https://doi.org")
            doi = mainlink[mainlink.index("doi.org/")+8..]
            line = line + " DOI: " + doi + "."
          end
          if !finallink.nil?
            line = line + " " + finallink
            if finallink != mainlink
              line = line + " ; Recommended: " + mainlink
            end
          else
            line = line + " " + mainlink
          end

          results << "<li id=\"#{shortrefid}\">(#{CGI::escapeHTML(shortref.gsub("]", ")"))}: #{Anchored::Linker.auto_link(Kramdown::Document.new(line, input: 'GFM').to_html)}</li>\n"
        end
        results << "</ol>\n"
        results << "</details>\n"
      end
      return results
    end
  end
end

Liquid::Template.register_tag('render_references', Jekyll::ReferencesTag)
