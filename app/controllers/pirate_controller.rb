require 'net/http'

class PirateController < ApplicationController

  def download
    hosts = ["http://quluxingba.info", "http://thepiratebay.se"]
    magnet = magnet(hosts[1],params[:series],params[:season],params[:episode])
    @url = magnet
    redirect_to magnet

    rescue Timeout::Error => e
      magnet = magnet(hosts[0],params[:series],params[:season],params[:episode])
      redirect_to magnet
  end

  private

  def magnet host, series, season, episode
    path = "#{host}/search/#{series} s#{season.rjust(2,'0')}e#{episode.rjust(2,'0')}/0/7/208"
    uri = URI.parse URI.escape(path)
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
