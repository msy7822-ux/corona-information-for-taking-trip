class Firesbase
  require 'google/cloud'

  class_attribute :connecting
  self.connecting = Google::Cloud.new(コンソールで作成したプロジェクトネーム).firestore
end