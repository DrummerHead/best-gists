require 'nokogiri'
require 'open-uri'


# Scarpe the site and aquire a lovely array

doc = Nokogiri::HTML(open('http://www.dobi.nu/yourscenesucks/left2.htm'))
root = 'http://www.dobi.nu/yourscenesucks/'

scene_links = []
scene_and_bands = []

doc.css('table[width="248"] tr:first-child a').each do |link|
  go = link.attr('href')
  scene_links << root + go
end

scene_links.each do |i|
  selfo = i
  nomme = selfo.to_s.gsub('http://www.dobi.nu/yourscenesucks/', '').gsub('/index.htm', '')

  docco = Nokogiri::HTML(open(i))

  docco.css('td[width="121"]').each do |lala|
    raw = lala.content
    raw.gsub!(/^[ \t]*/, '')
    raw.gsub!(/\r\n\r\n[\s\S]*$/, '')
    list = raw.split(/\r\n/)
    list[0] = nomme

    scene_and_bands << list
  end
end

puts scene_and_bands.inspect



# Use the array to parse the info and return markup

scene_and_bands_for_links = Marshal.load(Marshal.dump(scene_and_bands))

scene_and_bands_for_links.each do |i|
  i.each_with_index do |item, j|
    unless j == 0
      unless item =~ / /
        item << ' music'
      end
      item.gsub!(' ', '+')
    end
  end
end

scene_and_bands.each_with_index do |scene, i|
  scene.each_with_index do |name, j|
    if j == 0
      puts "\n"
      puts "# [#{name}](http://www.dobi.nu/yourscenesucks/#{name}/index.htm)"
    else
      puts "* [#{name}](http://www.youtube.com/results?search_query=#{scene_and_bands_for_links[i][j]})"
    end
    puts "\n"
  end
end


