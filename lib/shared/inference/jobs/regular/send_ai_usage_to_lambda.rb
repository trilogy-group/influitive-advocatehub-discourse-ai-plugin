# AI-GEN START - cursor
# frozen_string_literal: true

module ::Jobs
  class SendAiUsageToLambda < ::Jobs::Base
    def execute(args)
      uri = URI("https://tdd5fcltlbvzzdca7h2ai6j6vy0locnc.lambda-url.us-east-1.on.aws/session")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
  
      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request.body = {
        product_id: args[:product_id],
        feature_id: args[:feature_id],
        version: args[:version],
        customer_id: args[:customer_id],
        user_id: args[:user_id],
        session_id: args[:session_id],
        environment: args[:environment],
        details: {
          model: args[:model],
          input_tokens: args[:input_tokens],
          output_tokens: args[:output_tokens],
          status: args[:status]
        },
        efficacy: [
          {
            metric_name: args[:metric_name],
            metric_value: args[:metric_value].to_f
          }
        ]
      }.to_json
  
      response = http.request(request)
  
      if response.code.to_i != 200
        Rails.logger.error("Failed to send AI usage to Lambda: #{response.body}")
      end
    end
  end
end
# AI-GEN END
