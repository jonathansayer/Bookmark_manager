require 'sinatra/base'
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative './models/link'
require_relative './models/tag'
require_relative './models/user'


class AppWeb < Sinatra::Base
  run! if app_file == $0
  set :views, proc { File.join(root, '..', 'views') }

  enable :sessions
  set :session_secret, 'super secret'

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do 
     erb :new_links
  end

  post '/links' do 
    tags = params[:tag].split(" ")
     link=Link.new(url: params[:url], 
                   title: params[:title])
    tags.each do |tag|
      link.tags <<  Tag.create(name: tag)
    end
    link.save
    redirect to ('/links')
  end

  get '/tags/:name' do 
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    erb:'users/new'
  end

  post '/users' do
    current_user
    redirect to('/links')
  end

  def current_user
    User.create(email: params[:email],
      password: params[:password])
    session[:user_id] = user.id
  end
end
