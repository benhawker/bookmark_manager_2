require 'sinatra/base'
require 'byebug'
require 'sinatra/flash'
require_relative '../data_mapper_setup'
require_relative './models/link'
require_relative './models/user'

class App < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash


  get '/' do
    erb :index
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email], password: params[:password],
                    password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end


  get '/links' do
  	@links = Link.all
  	erb :'/links/index'
  end 

  get '/links/new' do
  	erb :'links/new'
  end

  post '/links' do
  	link = Link.new(url: params[:url], 
                title: params[:title])
  	tag  = Tag.create(name: params[:tags]) 
  	link.tags << tag
    link.save                        
  	redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    # @links = tag ? tag.links : []
    if tag
      @links = tag.links
    else 
      @links = []
    end
    erb :'links/index'
  end

 helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
