require './lib/utils/corona_api_methods'

module GoogleApiMethods
  include CoronaApiMethods

  ### google_places APIのキー
  API_KEY = ENV['GOOGLE_PLACE_API_KEY']

  def access_google_places(lat, lng)
    rad = 5000
    types = "hospital"
    # url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{rad}&types=#{types}&sensor=false&language=ja&key=#{API_KEY}"

    # uri = URI.parse(url)

    hospital_infos = []
    access_api(uri)['results'].map{ |hash|
      your_location = [lat, lng]
      location = [hash["geometry"]["location"]["lat"], hash["geometry"]["location"]["lng"]]
      hospital_infos << [hash['name'], hash['vicinity'], location, your_location]
    }
    if hospital_infos.size == 0
      message = {
        "type": "text",
        "text": "近くに医療施設が見つかりませんでした。"
      }
      return message
    else
      return display_hospitals_flex_message(hospital_infos)
    end
  end
end