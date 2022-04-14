# frozen_string_literal: true

require 'spec_helper'

describe 'format, content_type' do
  include_context "#{MODEL_PARSER} swagger example"

  before :all do
    module V1
      module Resources
        class CustomersAPI < Grape::API
          format :json
          params do
            requires :phone_number, type: String, desc: 'The phone number of the customer you want to add.',
                     documentation: { in: 'body' }
            optional :email, desc: 'A customer\'s email address', documentation: { in: 'body' }
            optional :first_name, type: String, desc: 'The customer\'s first name', documentation: { in: 'body' }
          end
          post 'create' do
            { 'declared_params' => declared(params) }
          end

          add_swagger_documentation openapi_version: '3.0'
        end
      end
    end
  end

  def app
    ::V1::Resources::CustomersAPI
  end

  describe 'request body' do
    subject do
      get '/swagger_doc'
      JSON.parse(last_response.body)
    end

    specify do
      json_schema = subject['paths']['/create']['post']['requestBody']['content']['application/json']['schema']
      expect(json_schema).to eql("$ref" => "#/components/schemas/postCreate")
    end
  end
end
