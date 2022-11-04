class OpenAiClient

  def initialize(session_id: nil, client: nil)
    @session_id = session_id
    @client = client
  end

  def models
    client.models.list
  end

  def question(prompt)
    q = format_question(prompt)
    response = client.completions(
      parameters: {
          model: "text-davinci-001",
          max_tokens: 400,
          prompt: q,
          user: user_id
     })
  end

# response = openai.Completion.create(
#   model="text-davinci-002",
#   prompt="The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.\n\nHuman: Hello, who are you?\nAI: I am an AI created by OpenAI. How can I help you today?\nHuman: I'm doing well thanks!\nAI: That's great to hear! What can I help you with today?\nHuman: I'm planning a trip to Austin, TX\nAI: That sounds like a great idea! What are some of the things you're interested in doing there?\nHuman: Coffee\nAI:\n\nThere are plenty of great coffee shops in Austin! Here are a few that come highly recommended:\n\n- Caffe Medici\n-ao5gallery\n-Thunderbird Coffee\n-Cupid's Arrow\n-Epoch Coffee\n\nHave you had a chance to check out any of these places yet?\nHuman: I love Caffe Medici\nAI:\n\nI'm glad you like Caffe Medici! They have a great selection of coffee and espresso drinks. Have you tried any of their pastries?\nHuman: Not yet.  Who else has great pastries?\nAI:\n\nSome other great places for pastries in Austin are:\n\n-Gourdough's Public House\n-The Cake Plate\n-Houndstooth Coffee\n-The Violet Crown Social Club\n\nDo you have a particular type of pastry in mind?\nHuman: No, actually I think I'd like pizza\nAI:\n\nThere are plenty of great pizza places in Austin! Here are a few that come highly recommended:\n\n- Home Slice Pizza\n- Little Deli & Pizzeria\n- Bufalina\n- Via 313\n\nHave you had a chance to check out any of these places yet?\nHuman: OMG\nAI:\n\nII'm glad you're  excited about the prospectl of eating pizza in Austin! There are definitely some great places to get it. Let me know if you need any further recommendations.\nHuman: thanks",
#   temperature=0.9,
#   max_tokens=150,
#   top_p=1,
#   frequency_penalty=0,
#   presence_penalty=0.6,
#   stop=[" Human:", " AI:"]
# )

  def chat(new_prompt, prefix: nil)
    prefix ||= "The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.\n" +
      "\nHuman: Hello, who are you?\nAI: I am an AI created by OpenAI. How can I help you today?\nHuman: "

    response = client.completions(
      parameters: {
        model: "text-davinci-002",
        prompt: [prefix, new_prompt].join(" "),
        temperature: 0.9,
        max_tokens: 200,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0.6,
        stop: [" Human:", " AI:"]
      })
  end

  # Commands

  def fix_spelling(text)
    response = client.edits(
        parameters: {
            model: "text-davinci-edit-001",
            input: text,
            instruction: "Fix the spelling mistakes",
            user: user_id
        }
    )
  end


  # Utilities
  def format_question(prompt)
    prompt = prompt.to_s.squish
    if !prompt.last == "?"
      prompt += "?"
    end
    prompt
  end

  attr_reader :session_id

  def user_id
    @user_id ||= [Rails.env, session_id || SecureRandom.uuid].join("-")
  end

  def client
    @client ||= OpenAI::Client.new(access_token: Rails.application.credentials.openai[:token])
  end
end