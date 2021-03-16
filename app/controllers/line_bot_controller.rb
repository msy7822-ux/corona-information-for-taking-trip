require './lib/utils/google_api_methods'
require './lib/utils/corona_api_methods'
require './lib/utils/linebot_api_methods'
require './lib/utils/physical_condition'

class LineBotController < ApplicationController
  include CoronaApiMethods
  include LinebotApiMethods
  include PhysicalCondition
  include GoogleApiMethods
  # CSRFを無効化する
  protect_from_forgery except: [:callback]

  ### 体調チェックでの質問の数
  QUESTIONS_NUM = QUESTIONS.size
  ### 体調チェックの、現在の質問番号
  @@count = 0
  ### 体調チェック中かどうか？
  @@is_checking = false
  ### 体調チェックの返答によるポイント
  @@point = 0
  ### 前回、ユーザーが送信したメッセージ（テキスト）
  @@previous_message = nil
  ### 体調チェックのタイミング
  @@check_timing = nil





  def callback

    ### クラス変数たちの状態を確認する
    puts "@@count : #{@@count}"
    puts "@@is_checking : #{@@is_checking}"
    puts "@@point : #{@@point}"
    puts "@@previous_message : #{@@previous_message}"





    body = request.body.read
    # ### LINEプラットフォームからのPOST通信の署名
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      return head :bad_request
    end

    case event = client.parse_events_from(body)[0]
    ### ユーザーからの各イベントごとの処理
    when Line::Bot::Event::Follow
      ### usersテーブルに保存する処理を記述
      # userId取得
      userId = event['source']['userId']
      create_user(userId)
      return
    when Line::Bot::Event::Unfollow
      # userId取得
      userId = event['source']['userId']
      User.find_by(line_id: userId).destroy
      return
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Location
        lat = event["message"]["latitude"]
        lng = event["message"]["longitude"]
        access_google_places(lat, lng, event['replyToken'])
      end
      # userId取得
      userId = event['source']['userId']
    else
      receive_unrelated_message_while_question(event) unless @@count == 0
      return
    end




    ### 47都道府県の配列データの定数をprefectures変数に代入
    prefectures = PREFECTURES


    ### 位置情報のメッセージとテキストのメッセージ以外はスルーするというフィルタリング
    return if event.type != Line::Bot::Event::MessageType::Text && event.type != Line::Bot::Event::MessageType::Location


    ### ユーザーが前回のやり取りで、「医療施設を検索する」とした場合
    # if @@previous_message == '医療施設を検索する'
    #   ### 区切り文字が半角スペでも全角スペでも統一の区切り文字に変換する
    #   pref, city = event['message']['text'].split(/\　|\ /)

    #   ### 存在しない都道府県なら、処理を終了する
    #   unless prefectures.include?(pref)
    #     not_find_pref(event['replyToken'])
    #     @@previous_message = nil
    #     return
    #   end
    #   ### 存在しない市町村なら、処理を終了する(true or falseを返す)
    #   unless confirm_city_is_exist?(pref, city)
    #     not_find_city(event['replyToken'])
    #     @@previous_message = nil
    #     return
    #   end

    #   message = {
    #     type: 'text',
    #     text: "#{pref}の#{city}というところにお住まいなんですね！"
    #   }

    #   client.reply_message(event['replyToken'], message)
    # end








    ### ユーザーからのメッセージの種類に応じて、処理を分岐する
    if prefectures.include?(event['message']['text'])
      ### 体調チェック中にこのイベントが発火されたら、体調チェックを中断する
      if @@count != 0 || @@is_checking == true
        receive_unrelated_message_while_question(event, userId)
        return
      end

      message = create_positives_status_message(event['message']['text'])
      ### ユーザーに返信する
      client.reply_message(event['replyToken'], message)






    elsif event['message']['text'] == '全国'
      ### 体調チェック中にこのイベントが発火されたら、体調チェックを中断する
      if @@count != 0 || @@is_checking == true
        receive_unrelated_message_while_question(event, userId)
        return
      end

      ### FIXME:
      positives_num = positives_near_30days_all_prefectures.slice(-30, 30).map{|hash| hash["positive"].to_i}
      num = positives_num[29] - positives_num[0]

      message = {
        type: 'text',
        text: "全国の直近30日間の感染者数は#{num}人です。"
      }

      client.reply_message(event['replyToken'], message)








    elsif event['message']['text'] == '旅行の際に必要な対策を確認する'
      ### 体調チェック中にこのイベントが発火されたら、体調チェックを中断する
      if @@count != 0 || @@is_checking == true
        receive_unrelated_message_while_question(event, userId)
        return
      end
      ### ユーザーに返信する
      client.reply_message(event['replyToken'], counterplanes)







    elsif event['message']['text'] == '目的地の県の感染者数を知る'
      ### 体調チェック中にこのイベントが発火されたら、体調チェックを中断する
      if @@count != 0 || @@is_checking == true
        receive_unrelated_message_while_question(event, userId)
        return
      end

      # pp create_quick_reply_all
      message = {
        type: 'text',
        text: 'message'
      }
      client.reply_message(event['replyToken'], create_quick_reply_all)




    elsif event['message']['text'] == '将来の予測を確認する'
      ### 体調チェック中にこのイベントが発火されたら、体調チェックを中断する
      if @@count != 0 || @@is_checking == true
        receive_unrelated_message_while_question(event, userId)
        return
      end

      predict_total_positives = predict_future_positives.map{|hash| "#{hash["date"].to_s.slice(-4, 4)}, #{hash["positive"]}" }
      message = {
        type: 'text',
        text: predict_total_positives.join("\n")
      }
      client.reply_message(event['replyToken'], message)



    # elsif event['message']['text'] == '旅行後です🙅‍♂️' || event['message']['text'] == '旅行前です🙆‍♂️'
    #   ### 一個前のメッセージが「体調チェックをする」になっていないとreturn
    #   return if @@previous_message == '体調チェックをする'

    #   ### 体調チェック中に送信された時の処理
    #   if @@count != 0 && @@is_checking
    #     ### クラス変数の初期化処理
    #     initialize_class_variable
    #     stop_question_message(event['replyToken'])
    #     return
    #   end

    #   ### 体調チェック時以外はスルーする
    #   return if (event['message']['text'] == '旅行後です🙅‍♂️' || event['message']['text'] == '旅行前です🙆‍♂️') && @@count == 0 && @@is_checking == false

    #   if event['message']['text'] == '旅行前です🙆‍♂️'
    #     @@check_timing = 'before trip'
    #   elsif event['message']['text'] == '旅行後です🙅‍♂️'
    #     @@check_timing = 'after trip'
    #   end


    elsif event['message']['text'] == '体調チェックをする' || event['message']['text'] == 'はい🙆‍♂️' || event['message']['text'] == 'いいえ🙅‍♂️'

      ### 体調チェック時以外の「はい🙆‍♂️」、「いいえ🙅‍♂️」はスルーする
      return if (event['message']['text'] == 'はい🙆‍♂️' || event['message']['text'] == 'いいえ🙅‍♂️') && @@count == 0 && @@is_checking == false

      ### 質問中に「体調チェックをする」と押された場合に、質問を1からやり直す
      if event['message']['text'] == '体調チェックをする' && @@count != 0 && @@is_checking == true
        ### クラス変数の初期化処理
        initialize_class_variable
        stop_question_message(event['replyToken'])
        return
      end

      ### 体調チェック中に切り替える
      @@is_checking = true

      ### 何問目の質問かは、クラス変数で保持
      if @@count < QUESTIONS_NUM
        message, point = create_confirm_message(@@count)
        client.reply_message(event['replyToken'], message)
        @@point += point if event['message']['text'] == 'はい🙆‍♂️'
        @@count += 1
      elsif @@count == QUESTIONS_NUM
        ### ユーザーに表示するための診断結果を作成する
        diagnosis_result = create_diagnosis_result(@@point)
        client.reply_message(event['replyToken'], diagnosis_result)

        ### 旅行前なのか後なのか？
        if @@check_timing == 'before trip'
          User.update(condition_check_before_trip_is_ended: true)
        elsif @@check_timing == 'after trip'
          User.update(condition_check_before_trip_is_ended: false)
        end

        ### クラス変数の初期化処理
        initialize_class_variable
        return
      end





    elsif event['message']['text'] == '医療施設を検索する'
      ### 体調チェック中にこのイベントが発火されたら、体調チェックを中断する
      if @@count != 0 || @@is_checking == true
        receive_unrelated_message_while_question(event, userId)
        return
      end

      message = {
        type: 'text',
        text: "あなたの最寄りの医療施設を検索します。\nメッセージ入力欄のカメラマークの左から位置情報を送信してください。"
      }
      client.reply_message(event['replyToken'], message)

    ### その他大勢のメッセージ
    else
      ### 体調チェック中にこのイベントが発火されたら、体調チェックを中断する
      if @@count != 0 || @@is_checking == true
        receive_unrelated_message_while_question(event, userId)
        return
      end
    end

    ### 次回のメッセージにとっての、「前回のメッセージ」を格納する
    @@previous_message = event['message']['text']
  end





  private

  ### クラス変数たちを初期化するメソッド
  def initialize_class_variable
    @@count = 0
    @@point = 0
    @@is_checking = false
    @@previous_message = nil
    @@check_timing = nil
  end

  ### 体調チェック中に関係ないメッセージを送られた場合
  def receive_unrelated_message_while_question(event, line_id)
    message = {
      type: 'text',
      text: '体調チェックの質問と無関係なイベントが発生したため、体調チェックを中断します。🙇‍♂️'
    }
    ### クラス変数の初期化処理
    initialize_class_variable
    client.reply_message(event['replyToken'], message)
  end


  ### 体調チェックによる診断結果の作成
  def create_diagnosis_result(point)
    if point <= 0
      message = {
        type: "text",
        text: "あなたの危険ポイントは#{@@point}です\n体調に問題はなさそうですので、万全の対策をして旅行を楽しんでください！🤗",
        "quickReply": {
          "items": [
            {
              "type": "action",
              "imageUrl": "",
              "action": {
                "type": "message",
                "label": "旅行の際に必要な対策を確認する",
                "text": "旅行の際に必要な対策を確認する"
              }
            }
          ]
        }
      }
    ### FIXME: もっと多くの情報を（保健所など、、、）
    elsif point < 2
      message = {
        type: "text",
        text: "あなたの危険ポイントは#{@@point}です\n感染していると断定はできませんが、不安ならかかりつけ医に電話相談し旅行は控えたほうが良いかもしれませんね。😥",
        "quickReply": {
          "items": [
            {
              "type": "action",
              "imageUrl": "",
              "action": {
                "type": "message",
                "label": "医療施設を検索する",
                "text": "医療施設を検索する"
              }
            }
          ]
        }
      }
    elsif point < 9
      message = {
        type: "text",
        text: "あなたの危険ポイントは#{@@point}です\n旅行は中止し、かかりつけ医に電話相談しその指示に従ってください。😖",
        "quickReply": {
          "items": [
            {
              "type": "action",
              "imageUrl": "",
              "action": {
                "type": "message",
                "label": "医療施設を検索する",
                "text": "医療施設を検索する"
              }
            }
          ]
        }
      }
    elsif point >= 10
      message = {
        type: "text",
        text: "あなたの危険ポイントは#{@@point}です\nあなたには、感染の疑いがあります。\n早急に保健所に連絡してください。😰",
        "quickReply": {
          "items": [
            {
              "type": "action",
              "imageUrl": "",
              "action": {
                "type": "message",
                "label": "医療施設を検索する",
                "text": "医療施設を検索する"
              }
            }
          ]
        }
      }
    end
  end


  ### 具体的な対策を表示するメソッド
  def counterplanes
    message = {
      type: 'text',
      text: "密集・密接・密室を避ける\nマスク\nアルコール消毒\n安全な距離を保つ\nこまめに手を洗う\n室内換気と咳エチケット\n接触確認アプリをインストール\n\nCOVID-19（新型コロナウイルス感染症）の感染拡大を防ぐには:\n手を清潔に保ちましょう。石けんで手洗いを行うか、手指消毒用アルコールで消毒を行いましょう。\n咳やくしゃみをする人からの距離を保ちましょう。\n対人距離を維持できない場合はマスクをしましょう。\n自分の目、鼻、口に触るのは止めましょう。\n咳やくしゃみをするときは、肘の内側またはティッシュ ペーパーで鼻と口を覆いましょう。\n具合が悪いときは自宅にいるようにしましょう。\n発熱、咳、呼吸が苦しい場合は、医師の診察を受けてください。\n事前に電話をすることで、医療従事者から適切な医療機関の案内を迅速に受けることができます。\nまた、マスクを使うことは、マスクを着用している人から他の人へのウイルスの拡散を防ぐのに役立ちます。 マスクだけでは COVID-19 を防ぐことはできませんので、対人距離の確保と手指衛生の維持を併せて行う必要があります。 地域の保健所の助言に従ってください。
      "
    }
  end
end

