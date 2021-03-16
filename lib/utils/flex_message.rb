# require './lib/utils/linebot_api_methods'
module FlexMessage
  # include LinebotApiMethods


  ### 感染者数のリプライのflex messageを作成する
  def positives_message(pref, total_positives, color, status)
    {
      "type": "flex",
      "altText": "this is a flex message",
      "contents": {
        "type": "bubble",
        "size": "mega",
        "header": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "#{pref}",
              "color": "#{color}",
              "size": "xxl",
              "align": "center"
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
              "text": "test",
              "contents": [
                {
                  "type": "span",
                  "text": "直近30日間　の感染者数："
                },
                {
                  "type": "span",
                  "text": "#{total_positives}人",
                  "weight": "bold"
                }
              ],
              "align": "center",
              "wrap": true
            }
          ]
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "test",
              "contents": [
                {
                  "type": "span",
                  "text": "危険度："
                },
                {
                  "type": "span",
                  "text": "#{status}",
                  "weight": "bold"
                }
              ],
              "align": "center"
            }
          ]
        }
      }
    }
  end






  ### flex messageを作成するメソッド
  def create_flex_message
    {
      type: 'flex',
      altText: '旅行の際に必要な対策一覧',
      contents: set_carousel
    }
  end

  ### carouselを作成するメソッド
  def set_carousel
    {
      type: 'carousel',
      contents: set_bubbles
    }
  end


  def set_bubbles
    [
      {
        "type": "bubble",
        "size": "giga",
        "header": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "旅行の際に必要な対策",
              "align": "center",
              "size": "lg",
              "margin": "xs"
            },
            {
              "type": "separator"
            }
          ]
        },
        "hero": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "align": "center",
                  "margin": "xs",
                  "size": "sm",
                  "contents": [
                    {
                      "type": "span",
                      "text": "一定の安全な距離を保つ　",
                      "decoration": "none",
                      "weight": "bold",
                      "size": "xs"
                    },
                    {
                      "type": "span",
                      "text": "3密を避ける",
                      "size": "xs",
                      "weight": "bold"
                    }
                  ],
                  "flex": 2
                }
              ]
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "margin": "md",
                  "size": "sm",
                  "align": "center",
                  "contents": [
                    {
                      "type": "span",
                      "text": "検温と体調チェック　",
                      "size": "xs",
                      "weight": "bold"
                    },
                    {
                      "type": "span",
                      "text": "アルコール消毒",
                      "size": "xs",
                      "weight": "bold"
                    }
                  ]
                }
              ]
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "hello, world",
                  "contents": [
                    {
                      "type": "span",
                      "text": "咳エチケットを守る　",
                      "size": "xs",
                      "weight": "bold"
                    },
                    {
                      "type": "span",
                      "text": "こまめな手洗い",
                      "size": "xs",
                      "weight": "bold"
                    }
                  ],
                  "align": "center",
                  "margin": "md"
                }
              ]
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "hello, world",
                  "contents": [
                    {
                      "type": "span",
                      "text": "接触確認アプリの取得　",
                      "size": "xs",
                      "weight": "bold"
                    },
                    {
                      "type": "span",
                      "text": "マスクの着用",
                      "size": "xs",
                      "weight": "bold"
                    }
                  ],
                  "margin": "md",
                  "size": "sm",
                  "align": "center"
                }
              ]
            }
          ]
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "separator"
            },
            {
              "type": "text",
              "text": "hello, world",
              "contents": [
                {
                  "type": "span",
                  "text": "COVID-19の感染拡大を防ぐには:",
                  "size": "sm"
                }
              ],
              "margin": "xl",
              "size": "sm"
            },
            {
              "type": "text",
              "text": "・手を清潔に保つ",
              "size": "xxs",
              "margin": "lg",
              "align": "start"
            },
            {
              "type": "text",
              "text": "・咳やくしゃみをする人から離れる。",
              "size": "xxs",
              "margin": "sm"
            },
            {
              "type": "text",
              "text": "・人混みの中ではマスクをする。",
              "size": "xxs",
              "margin": "sm"
            },
            {
              "type": "text",
              "text": "・自分の目、鼻、口に触るのは止めましょう。",
              "size": "xxs",
              "margin": "sm"
            },
            {
              "type": "text",
              "text": "・咳やくしゃみする時は、鼻と口を覆う。",
              "size": "xxs",
              "margin": "sm"
            },
            {
              "type": "text",
              "text": "・具合が悪いときは外出しない。",
              "size": "xxs",
              "margin": "sm"
            },
            {
              "type": "text",
              "text": "・発熱、咳などの症状があれば医者へ行く。",
              "margin": "sm",
              "size": "xxs"
            },
            {
              "type": "text",
              "text": "・マスクの着用は、ウィルスの拡散を防ぐ。",
              "margin": "sm",
              "size": "xxs"
            },
            {
              "type": "text",
              "text": "・何かあれば、早急に医者に相談する。",
              "margin": "sm",
              "size": "xxs"
            },
            {
              "type": "button",
              "action": {
                "type": "uri",
                "label": "厚生労働省の公式HPへ",
                "uri": "https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/0000164708_00001.html"
              }
            },
            {
              "type": "separator"
            },
            {
              "type": "spacer"
            }
          ]
        }
      }
    ]
  end

end