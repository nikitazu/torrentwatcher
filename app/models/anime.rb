require 'net/http'
require 'rss'

class Anime < ActiveRecord::Base
  belongs_to :user
  
  validates :episodes, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :progress, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  
  default_scope -> { order :updated_at => :desc }
  after_initialize :set_defaults
  
  scope :current, -> { where is_deleted: false }
  scope :deleted, -> { where is_deleted: true }
  
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
    url = "http://www.nyaa.se/?page=rss&cats=1_37&term=#{self.query_term}"
    logger.debug "looking up torrents at #{url}"
    torrents = []
    begin
      try_parse_rss url, torrents
    rescue Exception => ex
      return :error
    end
    torrents.sort_by! { |x| [x.seeders, x.downloads, x.weight] }
    torrents.reverse!
    return torrents
  end
  
  protected
    def set_defaults
      self.is_deleted = false if self.is_deleted.nil?
      self.score = 0 if self.score.nil? or self.score > 10 or self.score < 0
      self.progress = 0 if self.progress.nil?
    end
  
  private
    def try_parse_rss(url, torrents)
      open(url) do |rss|
        logger.debug "rss #{url} is opened"
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          torrents << Torrent.new(item)
        end
      end
    end
end


