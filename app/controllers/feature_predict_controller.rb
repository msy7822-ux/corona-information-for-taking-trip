require './lib/utils/corona_api_methods'

class FeaturePredictController < ApplicationController
  include CoronaApiMethods

  def index
    predict_total_positives = predict_future_positives.map{|hash| "#{hash["date"].to_s.slice(-4, 4)}, #{hash["positive"]}" }
    first_days_last_days_for_a_week = []

    predict_total_positives.each_slice(7){|arr|
      array = []
      if arr.size == 7
        array << arr.first.split(', ')
        array << arr.last.split(', ')

        first_days_last_days_for_a_week << array
      end
    }

    positives_each_week = first_days_last_days_for_a_week.map{ |first_day, last_day|
      incremented_positive_num = last_day[1].to_i - first_day[1].to_i
      first_day = first_day[0].insert(2, '/')
      last_day = last_day[0].insert(2, '/')

      [first_day, last_day, incremented_positive_num]
    }

    weeks = positives_each_week.map{|week| "#{week[0]} ~ #{week[1]}" }
    positive_nums = positives_each_week.map(&:third)

    @graph = LazyHighCharts::HighChart.new('graph') do |graph|
      graph.title(text: '日本の将来の感染者数の予測推移') # タイトル
      graph.xAxis(categories: weeks) # 横軸
      graph.series(name: '感染者数', data: positive_nums) # 縦軸
    end
  end
end
