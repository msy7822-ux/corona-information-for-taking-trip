namespace :line_bot do
  desc 'LINEBOTにpush通知させる処理'
  task scheduler_push: :environment do
    require './lib/utils/linebot_api_methods'
    include LinebotApiMethods
    ### 旅行前の健康チェックがなされている && 旅行後の健康チェックがなされていないユーザーに対して、一定時間おきにプッシュ通知を送信する
    message = {
      type: 'text',
      text: '体調チェックのお時間です。',
      "quickReply": {
        "items": [
          {
            "type": "action",
            "imageUrl": "",
            "action": {
              "type": "message",
              "label": "体調チェックをする",
              "text": "体調チェックをする"
            }
          }
        ]
      }
    }
    ### 出発前の体調チェックを終えているユーザーのみを取得
    users_checked_condition = User.where(condition_check_before_trip_is_ended: true)
    ### 出発前の体調チェック終えているユーザーに毎晩8時半に体調チェックをpush通知する　
    users_checked_condition.each do |user|
      client.push_message(user.line_id, message)
    end
  end
end