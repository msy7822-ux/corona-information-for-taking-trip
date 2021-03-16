# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development

# 実行環境の設定
set :environment, rails_env
# ログの出力先の設定
set :output, "#{Rails.root}/log/cron.log"

every 1.day, at: ['21:30 pm'] do # タスクを処理するペースを記載する。（例は毎晩８：３０に実行）
  rake 'line_bot:scheduler_push'
end
