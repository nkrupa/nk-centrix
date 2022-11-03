FactoryBot.define do
  factory :ai_request, class: 'Ai::Request' do
    session_id { "MyString" }
    query { "MyText" }
    response { "MyString" }
    response_text { "MyText" }
    tokens { 1 }
  end
end
