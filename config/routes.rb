Rails.application.routes.draw do
  get 'feature_predict/index'
  get 'maps/index'
  get 'home/index'
  # LINE plattformからデータを受け取る場合はPOST
  post '/callback' => 'line_bot#callback'
end
