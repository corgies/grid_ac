require 'zlib'
require 'json'
require 'open-uri'

# Usage: $ ruby grid_crawler_dic.rb Filepath (Input)
# Input: grid_idのリスト (1行区切りのgrid_idのリスト)
# Output: result.json

@num = 1

def crawler(grid_id)
  uri = 'https://grid.ac/institutes/' + grid_id

  hash = Hash.new
  hash['grid_id'] = grid_id
  hash['parent'] = Hash.new
  hash['count_parent'] = 0
  prev_line = nil
  flag_type = false
  flag_institute_link = false
  flag_parent = false
  name_original = nil

  open(uri){|file|
    while line = file.gets
      line.chomp!


      if prev_line == "<h1 class='text-center'>"
        if %r{<span class='institute-name'.*?>(.*?)</span>} =~ line
          name_original = $1
          hash['name_original'] = name_original
        end
      end
      # ------- type -------
      if line == "<ul class='types'>"
        flag_type = true
        hash['types'] = Array.new
      end

      if flag_type == true
        if %r{^<li>(.*?)</li>$} =~ line
          type = $1
          hash['types'].push(type)
        end
      end

      if flag_type == true && line == '</ul>'
        flag_type = false
      end
      # ------- END type -------

      # ------- Institute Links -------
      if line == '<dt>Institute Links</dt>'
        flag_institute_link = true
        hash['links'] = Array.new
      end

      if flag_institute_link == true && line == '</ul>'
        flag_institute_link = false
      end

      # ------- Links (web site) -------
      if flag_institute_link == true
        if %r{^<li><a href="(.*?)" itemprop="sameAs".*?>.*?</a></li>$} =~ line
          link = $1
          hash['links'].push(link)
        end
      end

      # ------- Wikipedia -------
      if %r{^<a href="(http://en.wikipedia.org/wiki/.*?)".*?$} =~ line
        wikipedia = $1
        hash['wikipedia'] = $1
      end
      # ------- END Wikipedia -------

      # ------- label (language, name) -------
      if %r{^<dd class='label_value' itemprop='alternateName'>(.*?)</dd>$} =~ line
        name = $1
        if %r{^<dt class='label_language'>(Japanese|English)</dt>$} =~ prev_line
          lang = $1
          if lang == 'Japanese'
            hash['name_ja'] = name
          elsif lang == 'English'
            hash['name_en'] = name
          else
            raise 'Error'
          end
        end
      end
     # ------- END label -------

      # ------- Parent -------
      if %r{^<ul class='parents' itemprop='memberOf' itemscope itemtype='http://schema.org/Organization'>$} =~ line
        flag_parent = true
      end

      if flag_parent == true
        if %r{<li itemprop='name'><a href="/institutes/(grid.*?)">(.*?)</a></li>} =~ line
          parent_grid_id = $1
          parent_name_original = $2
          hash['count_parent'] += 1
          hash['parent'][parent_grid_id] = parent_name_original
        end
      end

      if flag_parent == true && line == '</ul>'
        flag_parent = false
      end

      # ------- Location (country, country_code) -------
      if %r{<span itemprop='addressCountry'>(.*?)</span>$} =~ line
        country = $1
        hash['country'] = country
      end

      prev_line = line
    end
  }


  if hash.has_key?('name_ja') == false
    hash['name_ja'] = nil
  end

  if hash.has_key?('name_en') == false
    hash['name_en'] = name_original
  end

  if hash['parent'].length == 0
    hash['parent'] = nil
  end

  puts "#{@num}\t#{hash.to_json}"
  @num += 1
  return hash
end

hash_dic = Hash.new{|k,h| k[h]={}}


# ------- MAIN -------

ARGV.each{|filepath|
  File.open(filepath, 'r'){|file|
    while line = file.gets
      line.chomp!
      grid_id = line

      hash = crawler(grid_id)
      hash_dic[grid_id] = hash
      sleep(1.0) # option
    end
    file.close
  }
}

outpath = 'result.json'
File.open(outpath, 'w'){|outfile|
  outfile.puts JSON.pretty_generate(hash_dic)
  outfile.close
}
