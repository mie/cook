require 'mechanize'

def dump(thing)
  fname = File.join("ingredients-#{Time.now.to_i}.save")
  File.open( fname, 'w' ){ |f|
    Marshal.dump( thing, f )
  }
end
    
def load
  caches = Dir.glob("ingredients-*.save").sort {|a,b| File.mtime(b) <=> File.mtime(a)}
  File.open(caches[0]) { |f|
    thing = Marshal.load(f)
  } if caches != []
  return thing
end

urls = []
names = []
images = []

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

('a'..'z').each do |letter|
  a.get('http://www.bbc.co.uk/food/ingredients/by/letter/'+letter) do |page|
    page.search("li.resource.food").each do |lnk|
      lnk.search('a').each { |l| 
        names.push(l.text.strip)
        urls.push(l['href'])
      }
    end
  end
end
urls.each do |url|
  begin
    a.get('http://www.bbc.co.uk'+url) do |page|
      if page.search("img#food-image").size > 0
        page.search("img#food-image").each do |img|
          images.push(img['src'])
        end
      else
        images.push('')
      end
    end
  rescue
    images.push('')
  end
end

ingredients = Hash[names.zip(images)]
dump(ingredients)