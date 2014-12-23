# encoding: UTF-8
require 'psych'
require 'pry'
require 'yaml'
require 'video_info'

repo = '/Users/jcsouzaa/Documents/projetos/site-novo/'
files = Dir["#{repo}_posts/**/*.md"]
files.each do |file|
    puts file
    raw = File.open(file).read
    raw = raw.split("\n---\n")
    body = raw[1]
    metadata = Psych.load(raw[0])

    if metadata.has_key? 'video'
      unless metadata['video'].nil? || metadata['video'].empty?
        unless metadata.has_key? 'video_thumbnail'
          begin
            video = VideoInfo.new(metadata['video'])

            metadata['video_thumbnail'] = video.thumbnail_large if video.available?
          rescue VideoInfo::UrlError => e
            puts e.message
          end
        end
      end
    end

    # puts "Possui vídeo = #{metadata.has_key? 'video'}"
    # has_video = metadata.has_key? 'video' && !nil_or_empty(metadata['video'])
    # has_thumbnail = metadata.has_key? 'video_thumbnail'
    #
    # if has_video && !has_thumbnail
    #   puts "Entrou no if"
    #   begin
    #     video = VideoInfo.new(metadata['video'])
    #
    #     metadata['video_thumbnail'] = video.thumbnail_large if video.available?
    #   rescue VideoInfo::UrlError => e
    #     puts e.message
    #   end
    # end

    result = [Psych.dump(metadata),'---', body].join("\n")
    File.open(file, 'w') { |file| file.write(result) }
end

# def nil_or_empty var
#   puts "Se variavel é nula: #{var.nil?}"
#   puts "Se variavel está vazia: #{var.empty?}"
#   var.nil? || var.empty?
# end
