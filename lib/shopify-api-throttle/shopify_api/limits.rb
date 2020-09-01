module ShopifyAPI
  module Throttle
    module ClassMethods

      RETRY_AFTER_HEADER = 'retry-after'

      RETRY_AFTER = 10

      CREDIT_LIMIT_HEADER_PARAM = 'X-Shopify-Shop-Api-Call-Limit'

      ##
      # Have I reached my API call limit?
      # @return {Boolean}
      #
      def credit_below?(required = 1)
        credit_left < required
      end

      ##
      # @return {HTTPResponse}
      #
      def response
        Base.connection.response || { CREDIT_LIMIT_HEADER_PARAM => '10/40', RETRY_AFTER_HEADER => 0 }
      end

      ##
      # How many seconds until we can retry
      # @return {Integer}
      #
      def retry_after
        @retry_after = response[RETRY_AFTER_HEADER].to_i
        @retry_after = @retry_after == 0 ? RETRY_AFTER : @retry_after
      end
    end
  end
end
