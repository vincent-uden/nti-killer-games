class App < Sinatra::Base
  enable :sessions
  
  post '/account/login' do
    User.login params['email'], params['password'], session
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
end
