# GET request
get '/sample34' do
  haml :sample34
end

# POST request
post '/sample34' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :path, params[:path]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # create new Folder
    folder = GroupDocs::Storage::Folder.create!(settings.path, {:client_id => settings.client_id, :private_key => settings.private_key})
    if folder.id
       message = "You created new folder #{folder.path}"
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample34, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :message => message, :err => err}
end