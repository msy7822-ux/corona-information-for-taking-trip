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

  ### follow時に、DBにuserを保存する
  def create_user(line_id)
    ### unique: trueをつけたにもかかわらず、バリデーションが通過される。
    User.create!(line_id: line_id)
  end
end