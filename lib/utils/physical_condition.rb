module  PhysicalCondition
  QUESTIONS = [
    {"Q1. 37.5度以上の発熱はありますか?" => 4}, {"Q2. 味覚、嗅覚の異常は感じますか？" => 4}, {"Q3. 全身の異様なだるさは感じますか？" => 3}, {"Q4. 空咳は出ますか？" => 3}, {"Q7. 体に痛みは感じますか？" => 2}, {"Q5. 黄色い痰を伴う咳は出ますか？" => -3} ,{"Q6. 安静時にも息苦しいと感じることはありますか？" => 2}, {"Q8. 喉に痛みは感じますか？" => 1}, {"Q9. 下痢などはありますか？" => 1}, {"Q10. 鼻汁などはありますか？" => -1}, {"Q11. 新型コロナウイルスが陽性と診断された人との接触はありましたか？" => 6}, {"Q12. 自分や家族の流行地域または海外への往来はありましたか？" => 4}, {"Q13. 屋内イベントへの参加、カラオケ、ナイトクラブ、家族以外との飲食、密室でのおしゃべりはありましたか？" => 4}, {"Q14. 同じ職場内で、発熱、咳、嗅覚・味覚異常などの症状が出た人がいたことはありましたか？" => 3}
  ]

  def create_confirm_message(index)
    message = {
      "type": "template",
      "altText": "this is a confirm template",
      "template": {
        "type": "confirm",
        "text": "#{QUESTIONS[index].keys[0]}",
        "actions": [
          {
            "type": "message",
            "label": "はい",
            "text": "はい🙆‍♂️"
          },
          {
            "type": "message",
            "label": "いいえ",
            "text": "いいえ🙅‍♂️"
          }
        ]
      }
    }
    [message, QUESTIONS[index].values[0]]
  end



end