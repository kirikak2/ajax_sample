require 'rails_helper'

RSpec.describe "Addresses", type: :request do
  after(:each) do |example|
    assert_response_schema_confirm
  end

  describe "GET /addresses" do
    let!(:addresses) { create_list :address, 100 }
    subject { get addresses_path(format: "json") }
    it "works" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /addresses" do
    subject{ post addresses_path(format: "json"), params: params }
    let(:address) { build :address }
    let(:params) do
      { data: address.attributes }
    end
    it "works" do
      subject
      expect(response).to have_http_status(201)
    end
  end

  describe "PUT /addresses/:id" do
    let(:address) { create :address }
    subject { put address_path(address.id, format: "json"), params: params }
    let(:params) do
      {
        data: {
          name: "test",
          name_kana: "test"
        }
      }
    end
    it "works" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /addresses/:id" do
    let(:address) { create :address }
    subject { get address_path(address.id, format: "json") }
    it "works" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /addresses/:id" do
    let(:address) { create :address }
    subject { delete address_path(address.id, format: "json") }
    it "works" do
      subject
      expect(response).to have_http_status(204)
    end
  end
end
