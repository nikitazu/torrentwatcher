require 'net/http'
require 'rss'

class Anime < ActiveRecord::Base
  default_scope -> { where is_deleted: false }
  after_initialize :set_defaults
  
  def query_term
    title = self.title.gsub ' ', '+'
    if self.progress > 0
      next_episode = self.progress + 1
      next_episode_term = next_episode < 10 ? "0#{next_episode}" : "#{next_episode}"
      "#{title}+#{next_episode_term}"
    else
      title
    end
  end
  
  def lookup_torrents
    url = "http://www.nyaa.se/?page=rss&term=#{self.query_term}"
    logger.debug "looking up torrents at #{url}"
    torrents = []
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      logger.debug "Title: #{feed.channel.title}"
      feed.items.each do |item|
        logger.debug "Item: #{item.title}"
        torrents << Torrent.new(item)
      end
    end
    return torrents
  end
  
  protected
    def set_defaults
      if self.is_deleted.nil?
        self.is_deleted = false
      end
    end
end

class Torrent
  attr_accessor :title, :link, :description
  
  def initialize(item)
    self.title = item.title
    self.link = item.link
    self.description = item.description 
  end
end
