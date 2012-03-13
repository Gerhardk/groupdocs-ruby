module GroupDocs
  module Api
    module Helpers
      module REST

        DEFAULT_HEADERS = { accept: 'application/json',
                            content_length: 0 }

        private

        #
        # Prepares headers, method and payload for request.
        #
        # @api private
        #
        def prepare_request
          if options[:headers].is_a?(Hash)
            options[:headers].merge!(DEFAULT_HEADERS)
          else
            options[:headers] = DEFAULT_HEADERS
          end

          options[:method] = options[:method].downcase

          if options[:request_body] and not options[:request_body].is_a?(Object::File)
            options[:request_body] = options[:request_body].to_json
            options[:headers][:content_type] = 'application/json'
            options[:headers][:content_length] = options[:request_body].length
          end
        end

        #
        # Sends request to API server.
        #
        # @api private
        #
        def send_request
          self.response = case options[:method]
            when :get, :download
              resource[options[:path]].get(options[:headers])
            when :post
              resource[options[:path]].post(options[:request_body], options[:headers])
            when :put
              resource[options[:path]].put(options[:request_body], options[:headers])
            when :delete
              resource[options[:path]].delete(options[:headers])
            else
              raise GroupDocs::Errors::UnsupportedMethodError, "Unsupported HTTP method: #{options[:method].inspect}"
          end
        end

        #
        # Parses response from API server.
        #
        # @api private
        #
        def parse_response
          # for DOWNLOAD requests, just return response
          if options[:method] == :download
            response
          # for all other requests, parse JSON
          else
            json = JSON.parse(response, symbolize_names: true)
            json[:status] == 'Ok' ? json : raise_bad_request_error(json)
          end
        end

        #
        # @raise [GroupDocs::Errors::BadResponseError]
        # @api private
        #
        def raise_bad_request_error(json)
          raise GroupDocs::Errors::BadResponseError, <<-ERR
            Bad response!
            Request method: #{options[:method].upcase}
            Request URL: #{resource[options[:path]]}
            Request body: #{options[:request_body]}
            Status: #{json[:status]}
            Error message: #{json[:error_message]}
            Response body: #{response}
          ERR
        end

      end # Request
    end # Helpers
  end # Api
end # GroupDocs
