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
      text: "予想外のイベントが発生したので、体調チェックを中断します🙇‍♂️\n\n「体調チェック」というところをクリックすると、再度体調チェックを受けることができます。",
      "quickReply": {
        "items": [
          {
            "type": "action",
            "imageUrl": "",
            "action": {
              "type": "message",
              "label": "体調チェックをやり直す",
              "text": "体調チェックをする"
            }
          }
        ]
      }
    }
    client.reply_message(token, message)
  end

  ### follow時に、DBにuserを保存する
  def create_user(line_id)
    User.create!(line_id: line_id)
  end

  ### unfollow時に、ユーザーをDBから削除する
  def destroy_user(line_id)
    User.find_by(line_id: line_id).destroy
  end

  ### 正しい都道府県名じゃなかったときの返信
  def create_warning_prefecturs
    {
      "type": "flex",
      "altText": "医療施設の検索結果の一覧です。",
      "contents":     {
        "type": "bubble",
        "size": "mega",
        "header": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "注意",
              "margin": "sm",
              "size": "lg",
              "align": "center",
              "wrap": true,
              "adjustMode": "shrink-to-fit",
              "color": "#f30000"
            },
            {
              "type": "separator",
              "margin": "md"
            }
          ]
        },
        "hero": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "都道府県名は正式名称でお願いします🙇‍♂️",
              "contents": [],
              "align": "center",
              "wrap": true
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "hello, world",
                  "align": "center",
                  "margin": "xxl",
                  "contents": [
                    {
                      "type": "span",
                      "text": "例）　　　　　　"
                    }
                  ]
                },
                {
                  "type": "text",
                  "text": "❌東京 → ⭕️東京都",
                  "align": "center",
                  "size": "md",
                  "margin": "md"
                },
                {
                  "type": "text",
                  "text": "❌大阪 → ⭕️大阪府",
                  "align": "center",
                  "size": "md",
                  "margin": "lg"
                },
                {
                  "type": "text",
                  "text": "❌愛知 → ⭕️愛知県",
                  "align": "center",
                  "size": "md",
                  "margin": "lg"
                }
              ]
            }
          ]
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": []
        }
      }
    }
  end
end