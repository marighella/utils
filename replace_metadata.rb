# encoding: UTF-8
require 'psych'
require 'pry'
require 'yaml'

repo = '/Users/gcaires/Projects/mst/site-novo/'
files = Dir["#{repo}_posts/**/*.md"]
files.each do |file|
    puts file
    raw = File.open(file).read
    raw = raw.split("\n---\n")
    body = raw[1]
    metadata = Psych.load(raw[0])

    unless metadata["created_date"] then
      date = file.match /_posts\/.*\/(.{4})-(.{2})-(.{2})/
      date = date.captures.join("-")
      date += " 12:00"
      metadata["created_date"] = date.to_s
    end

    result = [Psych.dump(metadata),'---', body].join("\n")
    File.open(file, 'w') { |file| file.write(result) }

end
