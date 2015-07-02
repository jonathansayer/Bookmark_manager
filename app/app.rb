require 'sinatra/base'
require 'data_mapper'
require 'dm-postgres-adapter'
require 'sinatra/flash'
require_relative './models/link'
require_relative './models/tag'
require_relative './models/user'


class AppWeb < Sinatra::Base
 run! if app_file == $0
 set :views, proc { File.join(root, '..', 'views') }

 enable :sessions
 register Sinatra::Flash
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
  @user = User.new
   erb:'users/new'
 end

 post '/users' do
  @user = User.new(email: params[:email], 
              password: params[:password], 
              password_confirmation: params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else 
    flash.now[:notice] = "Password and confirmation password do not match"
    erb :'users/new'
  end
 end

helpers do 
  def current_user 
    user ||= User.first(id: session[:user_id])
  end
end

end