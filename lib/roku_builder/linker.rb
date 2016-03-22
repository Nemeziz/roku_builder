module RokuBuilder

  # Launch application, sending parameters
  class Linker < Util
    # Deeplink to the currently sideloaded app
    # @param options [String] Options string
    # @note Options string should be formated like the following: "<key>:<value>[, <key>:<value>]*"
    # @note Any options will be accepted and sent to the app
    def link(options:)
      path = "/launch/dev"
      return false unless options
      payload = Util.options_parse(options: options)

      unless payload.keys.count > 0
        return false
      end

      path = "#{path}?#{parameterize(payload)}"
      conn = multipart_connection(port: 8060)

      response = conn.post path
      return response.success?
    end

    private

    # Parameterize options to be sent to the app
    # @param params [Hash] Parameters to be sent
    # @return [String] Parameters as a string, URI escaped
    def parameterize(params)
      params.collect{|k,v| "#{k}=#{CGI.escape(v)}"}.join('&')
    end
  end
end
