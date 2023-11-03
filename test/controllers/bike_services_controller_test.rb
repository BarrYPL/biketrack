require "test_helper"

class BikeServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bike_service = bike_services(:one)
  end

  test "should get index" do
    get bike_services_url
    assert_response :success
  end

  test "should get new" do
    get new_bike_service_url
    assert_response :success
  end

  test "should create bike_service" do
    assert_difference("BikeService.count") do
      post bike_services_url, params: { bike_service: {  } }
    end

    assert_redirected_to bike_service_url(BikeService.last)
  end

  test "should show bike_service" do
    get bike_service_url(@bike_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_bike_service_url(@bike_service)
    assert_response :success
  end

  test "should update bike_service" do
    patch bike_service_url(@bike_service), params: { bike_service: {  } }
    assert_redirected_to bike_service_url(@bike_service)
  end

  test "should destroy bike_service" do
    assert_difference("BikeService.count", -1) do
      delete bike_service_url(@bike_service)
    end

    assert_redirected_to bike_services_url
  end
end
