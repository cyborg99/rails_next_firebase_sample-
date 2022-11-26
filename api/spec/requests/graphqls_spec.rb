require 'rails_helper'

RSpec.describe 'Graphqls' do
  describe 'GET /index' do
    it 'works! (now write some real specs)' do
      get graphqls_path
      expect(response).to have_http_status(:ok)
    end
  end
end
