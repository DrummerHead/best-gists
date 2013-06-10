#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

# Ask for name and check if it exists
args = ARGF.argv

if args.empty?
  puts "Type the name of the reddit user:"
  user = gets.chomp
elsif
  user = args[0]
end

begin
  user_overview_json = Nokogiri::HTML(open("http://www.reddit.com/user/" + user + ".json"))
rescue OpenURI::HTTPError
  puts "User does not exist or was not written correctly"
  exit
end


@comments = []
@next = 'http://www.reddit.com/user/' + user + '/comments'

# Function to put all comments from a single page into @comments
def comment_grab(url)
  doc = Nokogiri::HTML(open(url))

  doc.css('#siteTable .comment .noncollapsed').each do |comment|
    points = comment.css('.score.likes')
    body = comment.css('.md')
    permalink = comment.css('.first .bylink')

    @comments << [points.text.to_i, body.to_s, permalink.attr('href').to_s]
  end

  ness = doc.css('.nextprev a[rel="nofollow next"]')

  if ness.first
    @next = ness.attr('href').to_s
  else
    @next = ""
  end

  print "."
end

# If there's still pages to query, keep on
while @next.length > 0
  comment_grab(@next)
end

# Create new array with comments ordered by karma
ordered_by_karma = @comments.sort {|a, b, c| b[0] <=> a[0]}

# Create HTML with the contents of ordered_by_karma
File.open(user + ".html", "w") do |file|
  file.write("<!doctype html><html><head><title>#{user}'s reddit comments</title><meta charset='utf-8'><meta name='author' content='DrummerHead'><style> html { font-family: sans-serif; font-size: 1.2em; line-height: 1.4; } body { margin: 0; padding: 1em; color: #333; } [role='main'] { max-width: 54em; padding: 0; margin: 0 auto; list-style-type: none; } [role='main'] > li { margin: 0 0 5em; } body > h1 { max-width: 27em; margin: 2em auto; font-size: 2em; } .score { color: #777; font-size: 2em; font-weight: 100; } .md { overflow: auto;} .perma { color: #33339F; font-size: .7em; text-decoration: none; } .perma:hover { text-decoration: underline; } </style></head><body><h1>Last 1000 reddit posts ordered by score by #{user}</h1><ul role='main'>")
  ordered_by_karma.each do |points, body, perma|
    file.write("<li>")
    file.write("<strong class='score'>#{points}</strong>")
    file.write(body)
    file.write("<a class='perma' href='#{perma}'>#{perma}</a>")
    file.write("</li>")
  end
  file.write("</ul></body></html>")
end

# Helpful message
puts "\nCheck #{user}.html"