# GET request
get '/sample25' do
  haml :sample25
end

# POST request
post '/sample25' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :source, params[:source]
  set :file_id, params[:fileId]
  set :url, params[:url]
  set :base_path, params[:basePath]

  # Set download path
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  # Remove all files from download directory or create folder if it not there
  if File.directory?(downloads_path)
    Dir.foreach(downloads_path) { |f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..' }
  else
    Dir::mkdir(downloads_path)
  end

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # Get document by file GUID
    case settings.source
    when 'guid'
        # Create instance of File
        file = GroupDocs::Storage::File.new({:guid => settings.file_id})
    when 'local'
        # Construct path
        file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"
        # Open file
        File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # Make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(file_path, {})
    when 'url'
        # Upload file from defined url
        file = GroupDocs::Storage::File.upload_web!(settings.url)
    else
        raise 'Wrong GUID source.'
    end

    # Raise exception if something went wrong
    raise 'No such file' unless file.is_a?(GroupDocs::Storage::File)

    # Make GroupDocs::Storage::Document instance
    document = file.to_document

    # Create datasource with fields
    datasource = GroupDocs::DataSource.new

    # Get arry of document's fields
    fields = document.fields!()

    # Create Field instance and fill the fields
    datasource.fields = fields.map { |field| GroupDocs::DataSource::Field.new(name: field.name, type: :text, values: %w(value1 value2)) }

    # Adds datasource.
    datasource.add!()


    # Creates new job to merge datasource into document.
    job = document.datasource!(datasource, {:new_type => 'pdf'})
    sleep 10 # wait for merge and convert

    # Returns an hash of input and output documents associated to job.
    document = job.documents!()

    # Download file
    document[:inputs][0].outputs[0].download!("#{File.dirname(__FILE__)}/../public/downloads")

    # Set converted document GUID
    guid = document[:inputs][0].outputs[0].guid
    # Set converted document Name
    file_name = document[:inputs][0].outputs[0].name

    #Get url from request
    case settings.base_path

      when 'https://stage-api-groupdocs.dynabic.com'
        url = "http://stage-apps-groupdocs.dynabic.com/document-viewer/embed/#{guid}"
      when 'https://dev-api-groupdocs.dynabic.com'
        url = "http://dev-apps-groupdocs.dynabic.com/document-viewer/embed/#{guid}"
      else
        url = "https://apps.groupdocs.com/document-viewer/embed/#{guid}"
    end

    # Add the signature to url the request

    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url

    # Set iframe with document GUID or raise an error
    if guid
      iframe = "<iframe width='100%' height='600' frameborder='0' src='#{iframe}'></iframe>"
    else
      raise 'File was not converted'
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample25, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :fileName => file_name,  :err => err}
end