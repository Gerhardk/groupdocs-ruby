require 'groupdocs/storage/folder'
require 'groupdocs/storage/file'
require 'groupdocs/storage/package'


module GroupDocs
  module Storage

    #
    # Return an array of information about user's storage.
    #
    # @example
    #   GroupDocs::Storage.info!
    #   #=> { total_space: "1024 MB", available_space: "1020 MB", document_credits: 5000, available_credits: 4964 }
    #
    # @return [Array]
    #
    def self.info!
      json = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/storage/#{GroupDocs.client_id}"
      end.execute!

      {
        total_space:       "#{json[:result][:total_space] / 1048576} MB",
        available_space:   "#{json[:result][:avail_space] / 1048576} MB",
        document_credits:  json[:result][:doc_credits],
        available_credits: json[:result][:avail_credits]
      }
    end

  end # Storage
end # GroupDocs
