require "test_helper"

class FeaturePredictControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get feature_predict_index_url
    assert_response :success
  end
end
