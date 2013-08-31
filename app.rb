require "sinatra"
require "json"

enable :sessions
set :raise_errors, false
set :show_exceptions, false

helpers do
  def host
    request.env['HTTP_HOST']
  end

  def scheme
    request.scheme
  end

  def url_no_scheme(path = '')
    "//#{host}#{path}"
  end

  def url(path = '')
    "#{scheme}://#{host}#{path}"
  end

end

get "/" do
  
  erb :index
end

post '/parse' do
  json_string = params[:json]
  return [500, ["No JSON provided"]] if json_string.nil? || json_string.empty?
  
  urls = []
  begin
    json = JSON.parse(json_string)
    #j['windows'][0]['tabs'][0]['entries'][0]['url']
    json['windows'].each do |window|
      window['tabs'].each do |tab|
        tab['entries'].each do |entry|
          urls << entry['url']
        end
      end
    end
  rescue => e
    return [500, ["Error parsing JSON"]]
  end  
  
  return urls.to_json
end
