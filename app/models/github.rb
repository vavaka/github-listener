require 'open-uri'

class Github
  def self.get(url)
    open(url).read
  end

  def self.fetch_raw_data(options)
    get("https://raw.github.com/#{options[:user]}/#{options[:repo]}/#{options[:branch]}/#{options[:path]}")
  end
end
