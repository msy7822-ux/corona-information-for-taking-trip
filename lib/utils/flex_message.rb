module FlexMessage
  def create_hospitals_list(hospitals)
    contents = []
    hospitals.each do |hospital|
      contents << {"type": "separator"}
      contents << {
        "type": "text",
        "text": "#{hospital[0]}",
        "size": "md",
        "wrap": true,
        "adjustMode": "shrink-to-fit",
        "gravity": "center",
        "margin": "xl"
      }
      contents << {
        "type": "text",
        "text": "#{hospital[1]}",
        "size": "xxs",
        "wrap": true,
        "adjustMode": "shrink-to-fit",
        "gravity": "center"
      }
    end

    contents
  end


  def display_hospitals_flex_message(hospitals)
    {
      "type": "flex",
      "altText": "医療施設の検索結果の一覧です。",
      "contents": {
        "type": "carousel",
        "contents": [
          {
            "type": "bubble",
            "size": "mega",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "最寄りの医療施設一覧",
                  "size": "lg",
                  "align": "center",
                  "wrap": true,
                  "adjustMode": "shrink-to-fit"
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
                  "type": "image",
                  "url": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/hospital-71.png"
                }
              ]
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": create_hospitals_list(hospitals),
              "margin": "lg",
              "spacing": "none"
            }
          }
        ]
      }
    }
  end

  def create_boxes(array)
    contents = []
    array.each.with_index(1) do |data, index|
      contents << {
        "type": "text",
        "text": "将来の感染者の予測",
        "contents": [
          {
            "type": "span",
            "text": "第#{index}週目:　"
          },
          {
            "type": "span",
            "text": "#{data[0]} ~ #{data[1]}　"
          },
          {
            "type": "span",
            "text": "#{data[2]}人",
            "color": "#ff0000"
          }
        ],
        "size": "sm",
        "align": "center",
        "wrap": true,
        "adjustMode": "shrink-to-fit",
        "margin": "lg"
      }
    end

    contents
  end

  def create_predict_flex(array)
    {
      "type": "flex",
      "altText": "今後30日間の感染者数の予測です。",
      "contents": {
        "type": "bubble",
        "header": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "将来の感染者の予測",
              "size": "lg",
              "align": "center",
              "wrap": true,
              "adjustMode": "shrink-to-fit"
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
          "contents": create_boxes(array),
          "flex": 2
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": []
        }
      }
    }
  end


  ### 「ヘルプ」が押された際に表示するflex message
  def help_flex
    {
      "type": "flex",
      "altText": "このサービスについて",
      "contents":     {
        "type": "carousel",
        "contents": [
          {
            "type": "bubble",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "CoroInfonについて",
                  "size": "lg",
                  "wrap": true,
                  "align": "center",
                  "adjustMode": "shrink-to-fit"
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
                  "text": "このサービスの概要：",
                  "size": "sm"
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "text",
                      "text": "このサービスは、少しでも多くの人に",
                      "margin": "lg",
                      "adjustMode": "shrink-to-fit",
                      "wrap": true,
                      "align": "center",
                      "size": "xs"
                    },
                    {
                      "type": "text",
                      "text": "「安心して旅行を楽しんでもらう」",
                      "wrap": true,
                      "adjustMode": "shrink-to-fit",
                      "align": "center",
                      "weight": "bold",
                      "size": "xs"
                    },
                    {
                      "type": "text",
                      "text": "ために作成しました。",
                      "wrap": true,
                      "adjustMode": "shrink-to-fit",
                      "align": "center",
                      "size": "xs"
                    },
                    {
                      "type": "text",
                      "text": "安心して旅行できるというのはつまり、",
                      "adjustMode": "shrink-to-fit",
                      "wrap": true,
                      "align": "center",
                      "size": "xs",
                      "margin": "lg"
                    },
                    {
                      "type": "text",
                      "text": "感染せずに健康のまま旅行を楽しむ",
                      "size": "xs",
                      "weight": "bold",
                      "decoration": "none",
                      "align": "center",
                      "wrap": true,
                      "adjustMode": "shrink-to-fit"
                    },
                    {
                      "type": "text",
                      "text": "ことなので、そのために必要な機能を揃えました。",
                      "size": "xs",
                      "align": "center",
                      "wrap": true,
                      "adjustMode": "shrink-to-fit"
                    }
                  ]
                }
              ],
              "alignItems": "center",
              "offsetStart": "none",
              "borderWidth": "none"
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "搭載機能：",
                  "size": "sm",
                  "offsetStart": "none",
                  "margin": "xxl"
                },
                {
                  "type": "text",
                  "text": "damy",
                  "size": "xs",
                  "align": "center",
                  "contents": [
                    {
                      "type": "span",
                      "text": "体調チェック　"
                    },
                    {
                      "type": "span",
                      "text": "目的地の感染者数"
                    }
                  ],
                  "margin": "xxl"
                },
                {
                  "type": "text",
                  "text": "test",
                  "contents": [
                    {
                      "type": "span",
                      "text": "医療施設の検索　",
                      "size": "xs"
                    },
                    {
                      "type": "span",
                      "text": "予防対策の確認",
                      "size": "xs"
                    }
                  ],
                  "align": "center"
                },
                {
                  "type": "text",
                  "text": "将来30日間の感染者数の予測",
                  "size": "xs"
                },
                {
                  "type": "separator",
                  "margin": "md"
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "text",
                      "text": "それぞれの機能について：",
                      "size": "sm",
                      "margin": "md",
                      "align": "center"
                    },
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "text",
                          "text": "✔️体調チェック",
                          "margin": "xxl",
                          "size": "xs",
                          "align": "start",
                          "decoration": "underline"
                        },
                        {
                          "type": "text",
                          "text": "あなたの体調と接触歴に関する14個の簡単な質問に答えることで、そもそも自分が旅行に行ってもよい状態なのかどうか判定します。",
                          "margin": "lg",
                          "size": "xs",
                          "wrap": true,
                          "adjustMode": "shrink-to-fit"
                        },
                        {
                          "type": "text",
                          "text": "✔️目的地の感染者数",
                          "margin": "xl",
                          "size": "xs",
                          "decoration": "underline"
                        },
                        {
                          "type": "text",
                          "text": "あなたの旅行の目的地の「直近30日間」の感染者数を確認することができます。",
                          "size": "xs",
                          "margin": "lg",
                          "adjustMode": "shrink-to-fit",
                          "wrap": true
                        },
                        {
                          "type": "text",
                          "text": "✔️医療施設の検索",
                          "margin": "xl",
                          "size": "xs",
                          "decoration": "underline"
                        },
                        {
                          "type": "text",
                          "text": "あなたの現在の位置から半径5km以内にある医療施設の検索を行います。",
                          "size": "xs",
                          "wrap": true,
                          "adjustMode": "shrink-to-fit",
                          "align": "start",
                          "margin": "lg"
                        },
                        {
                          "type": "text",
                          "text": "✔️予防対策の確認",
                          "margin": "lg",
                          "size": "xs",
                          "decoration": "underline",
                          "wrap": true,
                          "adjustMode": "shrink-to-fit"
                        },
                        {
                          "type": "text",
                          "text": "旅行など、出かける際に必須の具体的な対策についてお知らせします。",
                          "margin": "lg",
                          "size": "xs",
                          "decoration": "none",
                          "wrap": true,
                          "adjustMode": "shrink-to-fit"
                        },
                        {
                          "type": "text",
                          "text": "✔️将来30日間の感染者数の予測",
                          "size": "xs",
                          "margin": "lg",
                          "decoration": "underline",
                          "wrap": true,
                          "adjustMode": "shrink-to-fit"
                        },
                        {
                          "type": "text",
                          "text": "統計学的に予測された将来30日間の感染者の推移を表示します。旅行を決定する際の一つの指標として参考にしてください。",
                          "size": "xs",
                          "margin": "lg",
                          "wrap": true,
                          "adjustMode": "shrink-to-fit"
                        },
                        {
                          "type": "text",
                          "text": "(※このデータは日本全体のデータです。)",
                          "size": "xs",
                          "margin": "sm",
                          "wrap": true,
                          "adjustMode": "shrink-to-fit"
                        }
                      ]
                    }
                  ],
                  "margin": "xxl"
                }
              ],
              "alignItems": "center",
              "borderWidth": "none",
              "spacing": "xs"
            }
          }
        ]
      }
    }
  end

  ### flex MessageとquickReplyが共存できなかったため
  def display_destination_positives
    {
      "type": "flex",
      "altText": "目的地の感染者数です。",
      "contents": {
        "type": "carousel",
        "contents": [
          {
            "type": "bubble",
            "size": "mega",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "目的地の感染者数",
                  "size": "lg",
                  "align": "center",
                  "wrap": true,
                  "adjustMode": "shrink-to-fit"
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
                  "text": "下から都道府県を一つ選択してください",
                  "size": "sm",
                  "align": "center",
                  "wrap": true,
                  "adjustMode": "shrink-to-fit"
                },
                {
                  "type": "spacer"
                }
              ]
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "※ 都道府県のボタンはランダムで生成されるため、全都道府県ありませんので入力欄から検索してください",
                  "wrap": true,
                  "adjustMode": "shrink-to-fit",
                  "size": "xs"
                },
                {
                  "type": "text",
                  "text": "また、下のボタンをクリックしていただければ、もう一度都道府県のボタンを生成することができます",
                  "wrap": true,
                  "adjustMode": "shrink-to-fit",
                  "size": "xs",
                  "margin": "lg"
                },
                {
                  "type": "button",
                  "action": {
                    "type": "message",
                    "label": "都道府県ボタンを生成する",
                    "text": "目的地の感染者数"
                  },
                  "margin": "lg",
                  "style": "secondary"
                }
              ]
            }
          }
        ]
      }
    }
  end


  ### 位置情報送信ボタンを表示する
  def display_geo_button
    {
      "type": "flex",
      "altText": "位置情報ボタンです。",
      "contents": {
        "type": "carousel",
        "contents": [
          {
            "type": "bubble",
            "size": "mega",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "医療施設検索",
                  "wrap": true,
                  "adjustMode": "shrink-to-fit",
                  "align": "center",
                  "size": "lg"
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
                  "text": "あなたの最寄りの医療施設を検索します。",
                  "adjustMode": "shrink-to-fit",
                  "wrap": true,
                  "margin": "none",
                  "size": "xs",
                  "align": "center",
                  "offsetStart": "none",
                  "offsetEnd": "none"
                },
                {
                  "type": "text",
                  "text": "下記のボタンから位置情報を送信してください。",
                  "align": "center",
                  "wrap": true,
                  "adjustMode": "shrink-to-fit",
                  "size": "xs",
                  "margin": "sm"
                }
              ],
              "margin": "none"
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "button",
                  "action": {
                    "type": "uri",
                    "label": "位置情報を送信する",
                    "uri": "line://nv/location"
                  },
                  "margin": "none",
                  "height": "sm",
                  "style": "secondary",
                  "adjustMode": "shrink-to-fit"
                }
              ]
            }
          }
        ]
      }
    }
  end


  ### 感染者数のリプライのflex messageを作成する
  def positives_message(pref, total_positives, color, status)
    {
      "type": "flex",
      "altText": "都道府県の感染者数です。",
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
                  "text": "直近30日間の感染者数："
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