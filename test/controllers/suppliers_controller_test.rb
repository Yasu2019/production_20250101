require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier = suppliers(:one)
  end

  test "should get index" do
    get suppliers_url
    assert_response :success
  end

  test "should get new" do
    get new_supplier_url
    assert_response :success
  end

  test "should create supplier" do
    assert_difference("Supplier.count") do
      post suppliers_url, params: { supplier: { address1: @supplier.address1, address2: @supplier.address2, automotive_related: @supplier.automotive_related, department: @supplier.department, departments: @supplier.departments, development: @supplier.development, fax: @supplier.fax, iso_existence: @supplier.iso_existence, manufacturer_name: @supplier.manufacturer_name, postal_code: @supplier.postal_code, qms: @supplier.qms, second_party_audit: @supplier.second_party_audit, supplier_development: @supplier.supplier_development, supplier_name: @supplier.supplier_name, target: @supplier.target, tel: @supplier.tel, transaction_details: @supplier.transaction_details } }
    end

    assert_redirected_to supplier_url(Supplier.last)
  end

  test "should show supplier" do
    get supplier_url(@supplier)
    assert_response :success
  end

  test "should get edit" do
    get edit_supplier_url(@supplier)
    assert_response :success
  end

  test "should update supplier" do
    patch supplier_url(@supplier), params: { supplier: { address1: @supplier.address1, address2: @supplier.address2, automotive_related: @supplier.automotive_related, department: @supplier.department, departments: @supplier.departments, development: @supplier.development, fax: @supplier.fax, iso_existence: @supplier.iso_existence, manufacturer_name: @supplier.manufacturer_name, postal_code: @supplier.postal_code, qms: @supplier.qms, second_party_audit: @supplier.second_party_audit, supplier_development: @supplier.supplier_development, supplier_name: @supplier.supplier_name, target: @supplier.target, tel: @supplier.tel, transaction_details: @supplier.transaction_details } }
    assert_redirected_to supplier_url(@supplier)
  end

  test "should destroy supplier" do
    assert_difference("Supplier.count", -1) do
      delete supplier_url(@supplier)
    end

    assert_redirected_to suppliers_url
  end
end
