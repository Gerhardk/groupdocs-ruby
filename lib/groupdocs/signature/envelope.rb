module GroupDocs
  class Signature::Envelope < Api::Entity

    require 'groupdocs/signature/envelope/log'

    STATUSES = {
      :draft       => -1,
      :annotation  =>  0,
      :in_progress =>  1,
      :expired     =>  2,
      :canceled    =>  3,
      :failed      =>  4,
      :completed   =>  5,
      :archived    =>  6,
      :scheduled   => 99,
    }

    include Api::Helpers::SignaturePublic
    include Signature::DocumentMethods
    include Signature::EntityFields
    include Signature::EntityMethods
    include Signature::FieldMethods
    include Signature::RecipientMethods
    extend  Signature::ResourceMethods

    #
    # Returns a list of all envelopes.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @option options [Integer] :status_id Filter by status identifier
    # @option options [String] :document Filter by document GUID
    # @option options [String] :recipient Filter by recipient email
    # @option options [String] :date Filter by date
    # @option options [String] :name Filter by name
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Envelope>]
    #
    def self.all!(options = {}, access = {})
      status_id = options.delete(:status_id)
      options[:statusId] = status_id if status_id

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/envelopes'
      end
      api.add_params(options)
      json = api.execute!

      json[:envelopes].map do |envelope|
        new(envelope)
      end
    end

    #
    # Returns a list of all envelopes where user is recipient.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @option options [Integer] :statusId Filter by status identifier
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Envelope>]
    #
    def self.for_me!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/envelopes/recipient'
      end
      api.add_params(options)
      json = api.execute!

      json[:envelopes].map do |envelope|
        new(envelope)
      end
    end

    # @attr [String] creationDateTime
    attr_accessor :creationDateTime
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [String] statusDateTime
    attr_accessor :statusDateTime
    # @attr [Integer] envelopeExpireTime
    attr_accessor :envelopeExpireTime
    # @attr [Boolean] isDemo
    attr_accessor :isDemo
    # @attr [Symbol] status
    attr_accessor :status

    # Human-readable accessors
    alias_accessor :creation_date_time,   :creationDateTime
    alias_accessor :status_date_time,     :statusDateTime
    alias_accessor :envelope_expire_time, :envelopeExpireTime
    alias_accessor :is_demo,              :isDemo

    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      STATUSES.invert[@status]
    end

    #
    # Adds recipient to envelope.
    #
    # @example
    #   roles = GroupDocs::Signature::Role.get!
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   recipient = GroupDocs::Signature::Recipient.new
    #   recipient.email = 'john@smith.com'
    #   recipient.first_name = 'John'
    #   recipient.last_name = 'Smith'
    #   recipient.role_id = roles.detect { |role| role.name == "Signer" }.id
    #   envelope.add_recipient! recipient
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def add_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient"
      end
      api.add_params(:email     => recipient.email,
                     :firstname => recipient.first_name,
                     :lastname  => recipient.last_name,
                     :role      => recipient.role_id,
                     :order     => recipient.order)
      api.execute!
    end

    #
    # Modify recipient of envelope.
    #
    # @example
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   recipient = envelope.recipients!.first
    #   recipient.first_name = 'Johnny'
    #   envelope.modify_recipient! recipient
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def modify_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient/#{recipient.id}"
      end
      api.add_params(:email     => recipient.email,
                     :firstname => recipient.first_name,
                     :lastname  => recipient.last_name,
                     :role      => recipient.role_id,
                     :order     => recipient.order)
      api.execute!
    end

    #
    # Delegates recipient to another one.
    #
    # @example
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   old = envelope.recipients!.first
    #   old.first_name = 'Johnny'
    #   new = GroupDocs::Signature::Recipient.new
    #   new.email = 'john@smith.com'
    #   new.first_name = 'John'
    #   new.last_name = 'Smith'
    #   envelope.delegate_recipient! old, new
    #
    # @param [GroupDocs::Signature::Recipient] old
    # @param [GroupDocs::Signature::Recipient] new
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if old recipient is not GroupDocs::Signature::Recipient
    # @raise [ArgumentError] if new recipient is not GroupDocs::Signature::Recipient
    #
    def delegate_recipient!(old, new, access = {})
      old.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Old recipient should be GroupDocs::Signature::Recipient object, received: #{old.inspect}"
      new.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "New recipient should be GroupDocs::Signature::Recipient object, received: #{new.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient/#{old.id}/delegate"
      end
      api.add_params(:email     => new.email,
                     :firstname => new.first_name,
                     :lastname  => new.last_name)
      api.execute!
    end

    #
    # Fills field with value.
    #
    # Value differs depending on field type. See examples below.
    #
    # @example Fill single line field
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   document = envelope.documents!.first
    #   recipient = envelope.recipients!.first
    #   field = envelope.fields!(document, recipient).first
    #   envelope.fill_field! "my_data", field, document, recipient
    #
    # @example Fill signature field
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   document = envelope.documents!.first
    #   recipient = envelope.recipients!.first
    #   field = envelope.fields!(document, recipient).first
    #   signature = GroupDocs::Signature.get!.first
    #   envelope.fill_field! signature, field, document, recipient
    #
    # @example Fill checkbox field
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   document = envelope.documents!.first
    #   recipient = envelope.recipients!.first
    #   field = envelope.fields!(document, recipient).first
    #   envelope.fill_field! false, field, document, recipient
    #
    # @param [String, Boolean, GroupDocs::Signature] value
    # @param [GroupDocs::Signature::Field] field
    # @param [GroupDocs::Document] document
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] options
    # @option options [Boolean] :public Defaults to false
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Signature::Field] filled field
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    # @raise [ArgumentError] if document is not GroupDocs::Document
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def fill_field!(value, field, document, recipient, options = {}, access = {})
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      client_id = client_id(options[:public])
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/#{client_id}/envelopes/#{id}/documents/#{document.file.guid}/recipient/#{recipient.id}/field/#{field.id}"
      end

      type = field.field_type
      if type == :signature && value.is_a?(GroupDocs::Signature)
        api.add_params(:signatureId => value.id)
      else
        if type == :checkbox
          value = (value ? 'on' : 'off')
        end
        api.options[:request_body] = value
        api.options[:plain] = true
      end

      json = api.execute!
      Signature::Field.new(json[:field])
    end

    #
    # Signs envelope.
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] options
    # @option options [Boolean] :public Defaults to false
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def sign!(recipient, options = {}, ccess = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      client_id = client_id(options[:public])
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/#{client_id}/envelopes/#{id}/recipient/#{recipient.id}/sign"
      end.execute!
    end

    #
    # Declines envelope.
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def decline!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/recipient/#{recipient.id}/decline"
      end.execute!
    end

    #
    # Downloads signed documents to given path.
    # If there is only one file in envelope, it's saved as PDF.
    # If there are two or more files in envelope, it's saved as ZIP.
    #
    # @param [String] path Directory to download file to
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String] path to file
    #
    def signed_documents!(path, access = {})
      response = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DOWNLOAD
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/documents/get"
      end.execute!

      filepath = "#{path}/#{name}."
      if documents!.size == 1
        filepath << 'pdf'
      else
        filepath << 'zip'
      end

      Object::File.open(filepath, 'wb') do |file|
        file.write(response)
      end

      filepath
    end

    #
    # Downloads signed document to given path.
    #
    # @param [GroupDocs::Document] document Signed document
    # @param [String] path Directory to download file to
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String] path to file
    #
    def signed_document!(document, path, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"

      response = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DOWNLOAD
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/document/#{document.file.guid}"
      end.execute!

      filepath = "#{path}/#{name}.pdf"

      Object::File.open(filepath, 'wb') do |file|
        file.write(response)
      end

      filepath
    end

    #
    # Returns a list of audit logs.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Envelope::Log>]
    #
    def logs!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/logs"
      end.execute!

      json[:logs].map do |log|
        Log.new(log)
      end
    end

    #
    # Sends envelope.
    #
    # @param [Hash] webhook URL to be hooked after envelope is completed
    # @option webhook [String] :callbackUrl
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def send!(webhook = {}, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/send"
        request[:request_body] = webhook
      end.execute!
    end

    #
    # Archives completed envelope.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def archive!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/archive"
      end.execute!
    end

    #
    # Restarts expired envelope.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def restart!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/restart"
      end.execute!
    end

    #
    #  Get signed envelope document.
    #
    # @example
    #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
    #   document = GroupDocs::Storage::Folder.list!.last.to_document
    #   envelope.add_document! document
    #
    # @param [GroupDocs::Document] document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if document is not GroupDocs::Document
    #
    def get_envelope!(path, document, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
                                                   "Document should be GroupDocs::Document object, received: #{document.inspect}"

      response = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/document/#{document.file.guid}"
      end.execute!

      filepath = "#{path}/#{name}."
      if documents!.size == 1
        filepath << 'pdf'
      else
        filepath << 'zip'
      end

      Object::File.open(filepath, 'wb') do |file|
        file.write(response)
      end

      filepath
    end

    #
    # Cancel envelope.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def cancel!( access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/cancel"
      end.execute!
    end

    #
    # Retry sign envelope.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def retry!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/envelopes/#{id}/retry"
      end.execute!
    end

  end # Signature::Envelope
end # GroupDocs
