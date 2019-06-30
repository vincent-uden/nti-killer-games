class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  
  post '/account/login' do
    errors = User.login params['email'], params['password'], session
    flash[:errors] = errors
    redirect back
  end

  post '/account/logout' do
    session.destroy
  end

  before do
    if session[:user_id]
      @current_user = User.get id: session[:user_id]
    else
      @current_user = User.null_user
    end
  end

  not_found do
    status 404
    slim :'404', layout: false
  end

  get '/' do
    slim :index
  end

  get '/account/login' do
    slim :'account/login'
  end

  get '/account/new' do
    slim :'account/new'
  end

  post '/account/new' do
    errors = User.create_new_user params
    if errors.empty?
      redirect '/account/login'
    else
      flash[:errors] = errors
      redirect back
    end
  end
end
