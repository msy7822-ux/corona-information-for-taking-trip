require './lib/utils/corona_api_methods'
require './lib/utils/linebot_api_methods'


module GoogleApiMethods
  include CoronaApiMethods
  include LinebotApiMethods

  ### google_places APIのキー
  API_KEY = "AIzaSyAxyCrXh9y18f-HBWqZarIS0-0fV-cD6W8"

  def access_google_places(lat, lng, token)
    rad = 5000
    types = "hospital"
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{rad}&types=#{types}&sensor=false&language=ja&key=#{API_KEY}"

    uri = URI.parse(url)

    hospital_infos = ''

    access_api(uri)['results'].map{ |hash|
      hospital_infos += "#{hash['name']},\n#{hash['vicinity']}\n\n"
    }

    message = {
      type: 'text',
      text: hospital_infos
    }

    client.reply_message(token, message)
  end
end