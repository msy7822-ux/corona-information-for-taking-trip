require './lib/utils/flex_message'
module CoronaApiMethods
  include FlexMessage

  ### 47都道府県
  PREFECTURES = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
    "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
    "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
    "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
    "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
    "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
    "熊本県","大分県","宮崎県","鹿児島県","沖縄県"]

    ### 不正な47都道府県
  INVALID_PREFECTURES = ["青森","岩手","宮城","秋田","山形","福島",
    "茨城","栃木","群馬","埼玉","千葉","東京","神奈川",
    "新潟","富山","石川","福井","山梨","長野","岐阜",
    "静岡","愛知","三重","滋賀","京都","大阪","兵庫",
    "奈良","和歌山","鳥取","島根","岡山","広島","山口",
    "徳島","香川","愛媛","高知","福岡","佐賀","長崎",
    "熊本","大分","宮崎","鹿児島","沖縄"]


  ### 47都道府県を返す
  def all_prefectures
    PREFECTURES
  end

  ### 不正な47都道府県を返す
  def invalid_prefectures
    INVALID_PREFECTURES
  end

  def quick_reply_prefs
    # ["北海道", "宮城県", "千葉県","東京都","神奈川県","石川県", "愛知県", "京都府","大阪府","兵庫県", "福岡県", "沖縄県"]
    ### 47都道府県のうち、ランダムで12都道府県を取り出して、表示するようにする
    PREFECTURES.shuffle.slice(0, 12)
  end

  ### 直近３０日間の感染者数をユーザーに知らせるテキストメッセージを作成する
  def create_positives_status_message(pref_name)
    ### 直近30日のデータを取得する
    positives_near_30days = infected_number_for_each_prefecture(pref_name)['itemList'].slice(0, 30).map{|hash| hash["npatients"].to_i }.reverse

    total_positives = positives_near_30days[29] - positives_near_30days[0]
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
    params = URI.encode_www_form({predict: true})
    uri = URI.parse("https://covid19-japan-web-api.vercel.app/api/v1/total?#{params}")
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

  ### 全国のクイックリプライを用意する
  def create_quick_reply_all
    # items = [ {"type": "action", "imageUrl": "", "action": { "type": "message", "label": "その他の都道府県を検索する", "text": "その他の都道府県を検索する"}}]
    items = [ {"type": "action", "imageUrl": "",
      "action": {
        "type": "uri",
        "label": "その他の都道府県を調べる",
        "uri": "https://line.me/R/oaMessage/@777khyfa/"
      }
    }]
    p items[0]
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