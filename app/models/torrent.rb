class Torrent
  attr_accessor :title, :name, :link, :description, :group, :group_type, :weight
  
  def initialize(item)
    self.title = item.title
    self.link = item.link
    self.description = item.description
    self.name = self.title
    
    group_matcher = /^\[(\S+)\][\s|_]/
    group_match = group_matcher.match(self.title)
    self.group = group_match ? group_match[1] : ""
    self.name.gsub! group_matcher, ''
    parse_group!
  end
  
  def <=>(other)
    self.weight <=> other.weight
  end
  
  private
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
end
