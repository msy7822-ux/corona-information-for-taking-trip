require './lib/utils/linebot_api_methods'
require './lib/utils/flex_message'
module CoronaApiMethods
  include LinebotApiMethods
  include FlexMessage

  ### 47都道府県
  PREFECTURES = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
    "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
    "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
    "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
    "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
    "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
    "熊本県","大分県","宮崎県","鹿児島県","沖縄県"]


  ### 47都道府県を返す
  def all_prefectures
    PREFECTURES
  end

  def quick_reply_prefs
    # ["北海道", "宮城県", "千葉県","東京都","神奈川県","石川県", "愛知県", "京都府","大阪府","兵庫県", "福岡県", "沖縄県"]
    ### 47都道府県のうち、ランダムで12都道府県を取り出して、表示するようにする
    PREFECTURES.shuffle.slice(0, 12)
  end


  ### 存在する市町村なのか判定する
  def confirm_city_is_exist?(pref_name, city_name)
    ### 都道府県コードを取得する(01 ~ 47)
    pref_index = (PREFECTURES.index(pref_name) + 1).to_s

    ### 都道府県コードが一桁の場合、先頭に０を追加する
    pref_index = "0" + pref_index if pref_index.size == 1

    params = URI.encode_www_form({area: "#{pref_index}"})
    url = "https://www.land.mlit.go.jp/webland/api/CitySearch?#{params}"
    uri = URI.parse(url)
    all_cities = access_api(uri)['data'].map{|hash| hash['name'] }
    all_cities.include?(city_name)
  end


  ### 直近３０日間の感染者数をユーザーに知らせるテキストメッセージを作成する
  def create_positives_status_message(pref_name)
    ### 直近30日のデータを取得する
    positives_near_30days = infected_number_for_each_prefecture(pref_name)['itemList'].slice(0, 30).map{|hash| hash["npatients"].to_i }.reverse

    p total_positives = positives_near_30days[29] - positives_near_30days[0]
    ### 受け取りメッセージの型は気にしない

    ### 危険： #ff0000
    ### 注意： #ffd100
    ### 安全： #00a0df
    color = nil
    status = nil


    ### FIXME:
    if total_positives > 3000
      color = "#ff0000"
      status = "危険"
    elsif total_positives < 1000
      color = "#00a0df"
      status = "安全"
    elsif total_positives >= 1000
      color = "#ffd100"
      status = "注意"
    elsif total_positives >= 2000
      color = "#c76a00"
      status = "要注意"
    end

    ### 感染者メッセージを作成する
    positives_message(pref_name, total_positives, color, status)
  end


  ### 全国の直近３０日の感染者数を返す
  def positives_near_30days_all_prefectures
    url = "https://covid19-japan-web-api.now.sh/api/v1/total?history=true"
    uri = URI.parse(url)
    access_api(uri)
  end

  ### 各県の医療提供状況を取得する
  def medical_care_provide_status_for_each_prefecture(pref_name)
    # prefecture = "富山県"  # ユーザーからの入力によって変わる。
    params = URI.encode_www_form({prefName: "#{pref_name}"})
    uri = URI.parse("https://opendata.corona.go.jp/api/covid19DailySurvey?#{params}")
    access_api(uri)
  end

  ### 将来30日の日本の感染者数の予測
  def predict_future_positives
    uri = URI.parse("https://covid19-japan-web-api.now.sh/api/v1/total?predict=true")
    access_api(uri)
  end

  ### 各都道府県の直近30日の感染者データを取得する
  def infected_number_for_each_prefecture(pref_name)
    # prefecture = "愛知県"  # ユーザーからの入力によって変わる。
    params = URI.encode_www_form({dataName: "#{pref_name}"})
    uri = URI.parse("https://opendata.corona.go.jp/api/Covid19JapanAll?#{params}")
    access_api(uri)
  end

  ### 複数のAPIアクセスで共通する処理
  def access_api(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # APIに対してリクエストを送信(Getリクエスト)# エンコーディングを変更し、JSONの変換したレスポンスを返す
    response = http.request_get(uri).body.force_encoding("UTF-8")
    JSON.parse(response)
  end



  ### FIXME:
  ### 全国のクイックリプライを用意する
  def create_quick_reply_all
    items = [
      {"type": "action", "imageUrl": "", "action": { "type": "message", "label": "全国", "text": "全国"}}
    ]
    quick_reply_prefs.each do |pref|
      items << {"type": "action", "imageUrl": "", "action": { "type": "message", "label": "#{pref}", "text": "#{pref}"}}
    end
    message = {
      'type': 'text',
      'text': "都道府県を一つ選択してください\n\n※都道府県のボタンはランダムで生成されるため、全都道府県ありませんので入力欄から検索してください\n\nまた、「目的地の感染者数」ボタンをクリックしていただければ、もう一度都道府県のボタンを生成することができます",
      'quickReply': {
        'items': items
      }
    }
  end

end