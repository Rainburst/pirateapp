require 'spec_helper'

describe PirateController do

  describe "GET 'download'" do
    it "returns http success" do
      get 'download'
      response.should be_success
    end
  end

end
