module GroupDocs
  class Signature::Field < Api::Entity

    #
    # Returns array of predefined lists.
    #
    # @param [Hash] options Hash of options
    # @option options [String] :id Filter by identifier
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Field>]
    #
    def self.get!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/fields'
      end
      api.add_params(options)
      json = api.execute!

      json[:fields].map do |field|
        new(field)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] name
    attr_accessor :name
    # @attr [Integer] graphSizeW
    attr_accessor :graphSizeW
    # @attr [Integer] graphSizeH
    attr_accessor :graphSizeH
    # @attr [String] getDataFrom
    attr_accessor :getDataFrom
    # @attr [String] regularExpression
    attr_accessor :regularExpression
    # @attr [String] fontName
    attr_accessor :fontName
    # @attr [String] fontColor
    attr_accessor :fontColor
    # @attr [Integer] fontSize
    attr_accessor :fontSize
    # @attr [Boolean] fontBold
    attr_accessor :fontBold
    # @attr [Boolean] fontItalic
    attr_accessor :fontItalic
    # @attr [Boolean] fontUnderline
    attr_accessor :fontUnderline
    # @attr [Boolean] isSystem
    attr_accessor :isSystem
    # @attr [Integer] fieldType
    attr_accessor :fieldType
    # @attr [Boolean] acceptableValues
    attr_accessor :acceptableValues
    # @attr [String] defaultValue
    attr_accessor :defaultValue

    # Human-readable accessors
    alias_method :graph_size_w,        :graphSizeW
    alias_method :graph_size_w=,       :graphSizeW=
    alias_method :graph_size_width,    :graphSizeW
    alias_method :graph_size_width=,   :graphSizeW=
    alias_method :graph_size_h,        :graphSizeH
    alias_method :graph_size_h=,       :graphSizeH=
    alias_method :graph_size_height,   :graphSizeH
    alias_method :graph_size_height=,  :graphSizeH=
    alias_method :get_data_from,       :getDataFrom
    alias_method :get_data_from=,      :getDataFrom=
    alias_method :regular_expression,  :regularExpression
    alias_method :regular_expression=, :regularExpression=
    alias_method :font_name,           :fontName
    alias_method :font_name=,          :fontName=
    alias_method :font_color,          :fontColor
    alias_method :font_color=,         :fontColor=
    alias_method :font_size,           :fontSize
    alias_method :font_size=,          :fontSize=
    alias_method :font_bold,           :fontBold
    alias_method :font_bold=,          :fontBold=
    alias_method :font_italic,         :fontItalic
    alias_method :font_italic=,        :fontItalic=
    alias_method :font_underline,      :fontUnderline
    alias_method :font_underline=,     :fontUnderline=
    alias_method :is_system,           :isSystem
    alias_method :is_system=,          :isSystem=
    alias_method :field_type,          :fieldType
    alias_method :field_type=,         :fieldType=
    alias_method :acceptable_values,   :acceptableValues
    alias_method :acceptable_values=,  :acceptableValues=
    alias_method :default_value,       :defaultValue
    alias_method :default_value=,      :defaultValue=

    #
    # Creates signature field.
    #
    # @example
    #   field = GroupDocs::Signature::Field.new
    #   field.name = 'Field'
    #   field.create!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/field'
        request[:request_body] = to_hash
      end.execute!

      self.id = json[:field][:id]
    end

    #
    # Modifies signature field.
    #
    # @example
    #   field = GroupDocs::Signature::Field.get!.first
    #   field.name = 'Field'
    #   field.modify!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def modify!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/fields/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

  end # Signature::Field
end # GroupDocs
