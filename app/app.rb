require 'sinatra/base'
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative './models/link'
require_relative './models/tag'


class AppWeb < Sinatra::Base
  run! if app_file == $0
  set :views, proc { File.join(root, '..', 'views') }


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


end
