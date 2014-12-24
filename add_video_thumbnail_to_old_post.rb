# encoding: UTF-8
require 'psych'
require 'pry'
require 'yaml'
require 'video_info'

def nil_or_empty var
  var.nil? || var.empty?
end

def green_line(text)
  puts "\e[32m #{text}"
  print "\e[0m"
end

def red_line(text)
  puts "\e[31m #{text}"
  print "\e[0m"
end

repo = 'absolute/path/to/project/root/folder/'
files = Dir["#{repo}_posts/**/*.md"]
files.each do |file|
    raw = File.open(file).read
    raw = raw.split("\n---\n")
    body = raw[1]
    metadata = Psych.load(raw[0])
    has_video = metadata.has_key?('video') ? !nil_or_empty(metadata['video']) : false
    has_thumbnail = metadata.has_key?('video_thumbnail')

    if has_video && !has_thumbnail
      puts "Processando arquivo: #{file}"
      begin
        video = VideoInfo.new(metadata['video'])
        if video.available?
          metadata['video_thumbnail'] = video.thumbnail_large
          green_line "Thumbnail adicionado com sucesso ao vídeo #{metadata['video']}. Thumbnail: #{metadata['video_thumbnail']}"
        else
          red_line "Vídeo #{metadata['video']} indisponível."
        end
      rescue VideoInfo::UrlError => e
        red_line "Url do video incorreta. #{e.message}"
      end
    end

    result = [Psych.dump(metadata),'---', body].join("\n")
    File.open(file, 'w') { |file| file.write(result) }
end
