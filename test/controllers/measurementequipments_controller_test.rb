require "test_helper"

class MeasurementequipmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Deviseのテストヘルパーをインクルード
  setup do
    @measurementequipment = measurementequipments(:one)
    sign_in users(:one) # users(:one) はテスト用のユーザーフィクスチャを指します
  end

  test "should get index" do
    get measurementequipments_url
    assert_response :success
  end

  test "should get new" do
    get new_measurementequipment_url
    assert_response :success
  end

  test "should create measurementequipment" do
    assert_difference("Measurementequipment.count") do
      post measurementequipments_url, params: { measurementequipment: { calibration_in_house_external: @measurementequipment.calibration_in_house_external, categories: @measurementequipment.categories, control_no: @measurementequipment.control_no, external_calibration_laboratory: @measurementequipment.external_calibration_laboratory, laboratory_environmental_conditions: @measurementequipment.laboratory_environmental_conditions, manufacturer: @measurementequipment.manufacturer, measurement_accuracy: @measurementequipment.measurement_accuracy, measuring_instrument_test_equipment: @measurementequipment.measuring_instrument_test_equipment, measuring_range: @measurementequipment.measuring_range, model_name: @measurementequipment.model_name, product_measurement_item: @measurementequipment.product_measurement_item, reference_document_no: @measurementequipment.reference_document_no, remarks: @measurementequipment.remarks, scope_of_internal_testing_laboratories: @measurementequipment.scope_of_internal_testing_laboratories } }
    end

    assert_redirected_to measurementequipment_url(Measurementequipment.last)
  end

  test "should show measurementequipment" do
    get measurementequipment_url(@measurementequipment)
    assert_response :success
  end

  test "should get edit" do
    get edit_measurementequipment_url(@measurementequipment)
    assert_response :success
  end

  test "should update measurementequipment" do
    patch measurementequipment_url(@measurementequipment), params: { measurementequipment: { calibration_in_house_external: @measurementequipment.calibration_in_house_external, categories: @measurementequipment.categories, control_no: @measurementequipment.control_no, external_calibration_laboratory: @measurementequipment.external_calibration_laboratory, laboratory_environmental_conditions: @measurementequipment.laboratory_environmental_conditions, manufacturer: @measurementequipment.manufacturer, measurement_accuracy: @measurementequipment.measurement_accuracy, measuring_instrument_test_equipment: @measurementequipment.measuring_instrument_test_equipment, measuring_range: @measurementequipment.measuring_range, model_name: @measurementequipment.model_name, product_measurement_item: @measurementequipment.product_measurement_item, reference_document_no: @measurementequipment.reference_document_no, remarks: @measurementequipment.remarks, scope_of_internal_testing_laboratories: @measurementequipment.scope_of_internal_testing_laboratories } }
    assert_redirected_to measurementequipment_url(@measurementequipment)
  end

  test "should destroy measurementequipment" do
    assert_difference("Measurementequipment.count", -1) do
      delete measurementequipment_url(@measurementequipment)
    end

    assert_redirected_to measurementequipments_url
  end
end
