require 'net/http'

class PirateController < ApplicationController

  def download
    pirate_bay_url = "http://thepiratebay.se/search/#{params[:series]} s#{params[:season].rjust(2,'0')}e#{params[:episode].rjust(2,'0')}/0/7/208"
    @url = URI.parse URI.escape(pirate_bay_url)
    redirect_to(load_page @url)
  end

  private

  def load_page url
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    logger.debug { res.body }
    doc = Nokogiri::HTML(res.body)
    table = doc.css("div.detName")[0].parent.css('a')[1]['href']
    
    table
  end

end
