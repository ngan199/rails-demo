require "test_helper"

class IncomeDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get income_details_show_url
    assert_response :success
  end

  test "should get new" do
    get income_details_new_url
    assert_response :success
  end

  test "should get create" do
    get income_details_create_url
    assert_response :success
  end

  test "should get edit" do
    get income_details_edit_url
    assert_response :success
  end

  test "should get update" do
    get income_details_update_url
    assert_response :success
  end

  test "should get destroy" do
    get income_details_destroy_url
    assert_response :success
  end
end
