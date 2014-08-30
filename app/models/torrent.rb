class Torrent
  attr_accessor :title, :name, :link, :description,
    :group, :group_type, :weight,
    :seeders, :leechers, :downloads, :size, :size_units,
    :is_trusted, :is_remake, :is_a_plus,
    :resolution, :episode
  
  def initialize(item)
    self.title = item.title
    self.link = item.link
    self.description = item.description
    self.name = self.title
    
    pre_clean_name!
    group_matcher = /^\[(\S+)\][\s|_]/
    group_match = group_matcher.match(self.title)
    self.group = group_match ? group_match[1] : ""
    self.name.gsub! group_matcher, ''
    parse_group!
    parse_seeders!
    parse_ratings!
    parse_resolution!
    post_clean_name!
    parse_episode!
  end
  
  def <=>(other)
    self.weight <=> other.weight
  end
  
  private
    def pre_clean_name!
      self.name.gsub! /\d+x1080/, '1080p'
      self.name.gsub! /\d+x720/, '720p'
      self.name.gsub! /\d+x480/, '480p'
    end
    
    def post_clean_name!
      self.name.gsub! /(\[|\(|\s)(AAC|10-?bit|H264)(\]|\)|\s)/, ''
      self.name.gsub! /\.(mkv|avi|mp4)/, ''
      self.name.gsub! /_/, ' '
      self.name.gsub! /\[\]/, ''
      self.name.gsub! /\(\)/, ''
      self.name.gsub! /\[\w+\]/, ''
    end
    
    def parse_group!
      if /(HorribleSubs)|(Commie)/.match(self.group)
        self.group_type = "torrent-group-good"
        self.weight = -100
      elsif /HZCHO/.match(self.group)
        self.group_type = "torrent-group-sad"
        self.weight = 100
      else
        self.group_type = "torrent-group-normal"
        self.weight = 0
      end
    end
    
    def parse_seeders!
      description_match =/(\d+) seeder\(s\), (\d+) leecher\(s\), (\d+) download\(s\) - (\d+\.?\d*) ([G|M|K]iB)/.match(self.description)
      if description_match
        self.seeders = description_match[1].to_i
        self.leechers = description_match[2].to_i
        self.downloads = description_match[3].to_i
        self.size = description_match[4]
        self.size_units = description_match[5]
        self.is_trusted = description_match[6]
        self.is_remake = description_match[7]
      end
    end
    
    def parse_ratings!
      self.is_trusted = /Trusted/.match(self.description)
      self.is_remake = /Remake/.match(self.description)
      self.is_a_plus = /A\+/.match(self.description)
    end
    
    def parse_resolution!
      title_matcher = /((1080p)|(720p)|(480p))/
      title_match = title_matcher.match(self.name)
      if title_match
        self.name.gsub! title_matcher, ''
        self.resolution = title_match[1]
      end
    end
    
    def parse_episode!
      title_match = /[\s|\(|\[|-](\d{1,3})[$|\)|\]|\s|v]/.match(self.name)
      if title_match
        self.episode = title_match[1].to_i
      end
    end
end
