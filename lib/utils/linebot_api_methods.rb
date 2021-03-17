module LinebotApiMethods

  ### LINE Bot SDK RubyのAPIクライアントを取得する
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_ACCESS_TOKEN"]
    }
  end

  ### 質問中に「体調チェックをする」ボタンが押されたさいに、チェックを初めからやり直す趣旨のメッセージを送信する
  def stop_question_message(token)
    message = {
      type: 'text',
      text: '予想外のイベントが発生したので、体調チェックを中断します。🙇‍♂️'
    }
    client.reply_message(token, message)
  end

  ### 入力された都道府県が見つからなかった時の処理
  def not_find_pref(token)
    message = {
      type: 'text',
      text: 'ご入力いただいた都道府県名が見つかりませんでした。🙇‍♂️'
    }
    client.reply_message(token, message)
  end
  ###  入力された市町村が見つからなかった時の処理
  def not_find_city(token)
    message = {
      type: 'text',
      text: 'ご入力いただいた市町村名が見つかりませんでした。🙇‍♂️'
    }
    client.reply_message(token, message)
  end

  ### follow時に、DBにuserを保存する
  def create_user(line_id)
    ### unique: trueをつけたにもかかわらず、バリデーションが通過される。
    User.create!(line_id: line_id)
  end

  ### クイックリプライを作成する
  # def create_quick_reply(pref_name, total_positives, message)
  #   items = [
  #     {"type": "action", "imageUrl": "", "action": { "type": "message", "label": "全国", "text": "全国"}}
  #   ]
  #   quick_reply_prefs.each do |pref|
  #     items << {"type": "action", "imageUrl": "", "action": { "type": "message", "label": "#{pref}", "text": "#{pref}"}}
  #   end
  #   message = {
  #     'type': 'text',
  #     'text': "#{pref_name}の直近１ヶ月の感染者数#{total_positives}人",
  #     'quickReply': {
  #       'items': items
  #     }
  #   }
  # end

end