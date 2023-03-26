# coding: utf-8
# Set up initial message
messages = [
    {
      role: 'system',
      content: "Your role is to help a novice English speaker learn Japanese. You should respond to the user's messages in Japanese kanji, with a limited vocabulary and concise, conversational responses to make them easier to understand. You should also include phonetic help in parenthesis after each kanji or hiragana character, and provide the English translation in square brackets.

For each user message, you should first correct any mistakes in their Japanese and provide the corrected version with phonetic help and English translation. Even if the user is correct, you should provide the kanji and translation to ensure the message was as intended. This is the most important aspect of your responses and should never be left out. Then in the next part of the response, you should respond with a Japanese roleplaying message that follows logically from the user's message, using the same formatting for phonetics and translation. This part should be creative and invite the user to respond in some way.

For example, if the user says 'konichiwa', you should respond with 'こんにちは。(Konnichiwa) [Hello]' which is the corrected version of the user message, followed by a newline, and then a roleplaying response such as: '元気ですか ？ (Genki desu ka?) [How are you?]'."
    }
]

gpt_api_key = File.read("gpt_api_key").strip

# Continuously prompt for input and respond
loop do
    print 'You: '
    input = gets.chomp

    # Add user message to messages array
    messages << {
        role: 'user',
        content: input
      }

  # Send request to ChatGPT API
    uri = URI.parse("https://api.openai.com/v1/chat/completions")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{gpt_api_key}"
    request.body = {
        messages: messages,
        max_tokens: 3000,
        model: 'gpt-3.5-turbo'
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
    end

    # Parse response and extract answer
    begin
        answer = JSON.parse(response.body)['choices'][0]['message']['content'].strip
    rescue
        puts response.body
    end

    # Print answer
    puts "ChatGPT: #{answer}"

    # Add ChatGPT response to messages array
    messages << {
        role: 'system',
        content: answer
    }
end
