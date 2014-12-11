# encoding: UTF-8
require 'psych'
require 'pry'
require 'yaml'

repo = 'absolute/path/folder/with/markdowns'
files = Dir["#{repo}_posts/**/*.md"]
files.each do |file|
    puts file
    raw = File.open(file).read
    raw = raw.split("\n---\n")
    body = raw[1]
    metadata = Psych.load(raw[0])

    if metadata["tags"] && metadata['tags'].size > 0 then
      metatags = metadata['tags']
      new_tags = []
      metatags.each do |tag|
        new_tags.concat tag.values.map {|item| {"tag"=> item}}
      end
      puts 'Editing tags...'
      metadata["tags"] = new_tags
      result = [Psych.dump(metadata),'---', body].join("\n")
      File.open(file, 'w') { |file| file.write(result) }
    end

end
