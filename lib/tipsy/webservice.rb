require 'tipsy'
require 'sinatra'

get '/analyze' do
  text = params[:text]
  analyzer = Tipsy::TextAnalyzer.new(text)
  analyzer.run
  content_type :json
  { polarity: analyzer.polarity, text_ngrams: analyzer.text_ngrams }.to_json
end
