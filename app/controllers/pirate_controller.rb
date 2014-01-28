require 'net/http'

class PirateController < ApplicationController

  def download
    @is_argument_error = false
    validate_params
    hosts = ["http://quluxingba.info", "http://thepiratebay.se"]
    magnet = magnet(hosts[1],@series,@season,@episode)
    @url = magnet
    redirect_to magnet

    rescue Timeout::Error => e
      logger.error { e }
      magnet = magnet(hosts[0],@series,@season,@episode)
      redirect_to magnet
    rescue ArgumentError => e
      logger.error { e }
      @is_argument_error = true
    rescue Exception => e
      logger.error { e }

  end

  private

  def validate_params 
    @series = params[:series]
    @season = params[:season]
    @episode = params[:episode]
    Integer(@season)
    Integer(@episode)
  end

  def magnet host, series, season, episode
    path = "#{host}/search/#{series} s#{season.rjust(2,'0')}e#{episode.rjust(2,'0')}/0/7/208"
    uri = URI.parse URI.escape(path)
    @path = uri
    load_page uri
  end

  def load_page url
    req = Net::HTTP::Get.new(url.path)
    
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.read_timeout = 40
      http.request(req)
    }


    logger.debug { url }
    doc = Nokogiri::HTML(res.body)
    doc.css("div.detName")[0].parent.css('a')[1]['href']
  end

end
