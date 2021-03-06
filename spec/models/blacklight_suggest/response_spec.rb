require 'rails_helper'

describe BlacklightSuggest::Response do
  let(:empty_response) { BlacklightSuggest::Response.new({}, q: 'hello') }
  let(:response) do
    BlacklightSuggest::Response.new(
        {
            'responseHeader' => {
                'status' => 0,
                'QTime' => 42
            },
            'suggest' => {
                'mySuggester' => {
                    'st' => {
                        'numFound' => 2,
                        'suggestions' => [
                            {
                                'term' => 'stanford',
                                'weight' => 3,
                                'payload' => ''
                            },
                            {
                                'term' => 'statistics',
                                'weight' => 1,
                                'payload' => ''
                            }
                        ]
                    }
                }
            }
        },
        q: 'st'
    )
  end

  describe '#initialize' do
    it 'creates a BlacklightSuggest::Response' do
      expect(empty_response).to be_an BlacklightSuggest::Response
    end
  end
  describe '#suggestions' do
    it 'returns an array of suggestions' do
      expect(response.suggestions).to be_an Array
      expect(response.suggestions.count).to eq 2
      expect(response.suggestions.first['term']).to eq 'stanford'
    end
  end
end
