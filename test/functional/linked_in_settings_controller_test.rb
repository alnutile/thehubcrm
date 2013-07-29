require 'test_helper'

class LinkedInSettingsControllerTest < ActionController::TestCase
  setup do
    @linked_in_setting = linked_in_settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:linked_in_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create linked_in_setting" do
    assert_difference('LinkedInSetting.count') do
      post :create, linked_in_setting: { key: @linked_in_setting.key, secret: @linked_in_setting.secret, synced_last: @linked_in_setting.synced_last, total_count: @linked_in_setting.total_count }
    end

    assert_redirected_to linked_in_setting_path(assigns(:linked_in_setting))
  end

  test "should show linked_in_setting" do
    get :show, id: @linked_in_setting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @linked_in_setting
    assert_response :success
  end

  test "should update linked_in_setting" do
    put :update, id: @linked_in_setting, linked_in_setting: { key: @linked_in_setting.key, secret: @linked_in_setting.secret, synced_last: @linked_in_setting.synced_last, total_count: @linked_in_setting.total_count }
    assert_redirected_to linked_in_setting_path(assigns(:linked_in_setting))
  end

  test "should destroy linked_in_setting" do
    assert_difference('LinkedInSetting.count', -1) do
      delete :destroy, id: @linked_in_setting
    end

    assert_redirected_to linked_in_settings_path
  end
end
