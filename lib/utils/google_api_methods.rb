require './lib/utils/corona_api_methods'

module GoogleApiMethods
  include CoronaApiMethods

  ### google_places APIのキー
  API_KEY = ENV['GOOGLE_PLACE_API_KEY']

  def access_google_places(lat, lng)
    rad = 5000
    types = "hospital"
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{rad}&types=#{types}&sensor=false&language=ja&key=#{API_KEY}"

    uri = URI.parse(url)

    hospital_infos = []
    access_api(uri)['results'].map{ |hash|
      hospital_infos << [hash['name'], hash['vicinity']]
    }
    message = display_hospitals_flex_message(hospital_infos)
  end
end