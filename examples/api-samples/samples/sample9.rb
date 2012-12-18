get '/sample9' do
  haml :sample9
end

post '/sample9' do
  set :guid, params[:guid]
  set :width, params[:width]
  set :height, params[:height]

  begin
    raise "Please enter all required parameters" if settings.guid.empty? or settings.width.empty? or settings.height.empty?
    v_url = "https://apps.groupdocs.com/document-viewer/embed/#{settings.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      
    if v_url
      v_url = v_url
    end
  rescue Exception => e
    err = e.message
  end  
  
  haml :sample9, :locals => { :guid => settings.guid, :width => settings.width, :height => settings.height, :v_url=>v_url, :err => err }
end
