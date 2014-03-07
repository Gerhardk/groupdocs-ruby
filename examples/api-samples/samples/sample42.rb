# GET request
get '/sample42' do
  haml :sample42
end

# POST request
post '/sample42' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :file_id, params[:fileId]
  set :base_path, params[:basePath]

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

    document = GroupDocs::Storage::File.new(:guid => settings.file_id).to_document

    # Check, has document the annotations?
    raise 'Your document has no annotations' if document.annotations!.empty?

    # Create Hash with the options for job. :status=> -1 means the Draft status of the job
    options = {:actions => [:import_annotations], :name => 'sample'}

    # Create Job with provided options with Draft status (Sheduled job)
    job = GroupDocs::Job.create!(options)

    # Add the documents to previously created Job
    job.add_document!(document, {:check_ownership => false})


    # Update the Job with new status. :status => '0' mean Active status of the job (Start the job)
    id = job.update!({:status => '0'})

    i = 1

    while i<5 do
      sleep(5)
      job = GroupDocs::Job.get!(id[:job_id])
      break if job.status == :archived
      i  = i + 1
    end

    # Get the document into Pdf format
    file = job.documents!()

    document = file[:inputs]

    # Set iframe with document GUID or raise an error
    if document

      #Get url from request
      case settings.base_path

        when 'https://stage-api-groupdocs.dynabic.com'
          url = "http://stage-apps-groupdocs.dynabic.com/document-annotation/embed/#{document[0].guid}"
        when 'https://dev-api-groupdocs.dynabic.com'
          url = "http://dev-apps-groupdocs.dynabic.com/document-annotation/embed/#{document[0].guid}"
        else
          url = "https://apps.groupdocs.com/document-annotation/embed/#{document[0].guid}"
      end

      # Add the signature in url
      iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url
      iframe = "<iframe width='100%' height='600' frameborder='0' src='#{iframe}'></iframe>"

      path = "#{File.dirname(__FILE__)}/../public/downloads"
      GroupDocs::User.download!(path, document[0].outputs[0].name, document[0].outputs[0].guid)
      message = "<span style=\"color:green\">File with annotations was downloaded to server's local folder. You can check them <a href=\"/downloads/#{document[0].outputs[0].name}\">here</a></span>"
    else
      raise 'File was not converted'
    end
  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample42, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :err => err, :iframe => iframe, :message => message}
end
