
class App < Sinatra::Base
  # Password for admin page
  # killerpass123
  admin_pass = "$2a$12$n6mUrm6FG1nT42/6CsYgpu7UXXGvOqyVrPmvfhoR2CJCoBO5yq452"

  enable :sessions
  register Sinatra::Flash

  post '/account/login' do
    errors = User.login params['email'], params['password'], session
    flash[:errors] = errors
    if errors.empty?
      redirect '/'
    else
      redirect back
    end
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
    if !flash[:errors] 
      flash.now[:errors] = []
    end
  end

  not_found do
    status 404
    slim :'404', layout: false
  end

  get '/' do
    if @current_user.null?
      slim :index
    else
      redirect '/game/overview'
    end
  end

  get '/account/login' do
    slim :'account/login'
  end

  get '/account/new' do
    slim :'account/new'
  end

  get '/admin/overview' do
    if session[:admin]
      @is_admin = true
      @users = User.select(order_by: 'class, first_name').map { |x| User.new x  }
    else
      @is_admin = false
    end


    slim :'admin/overview'
  end

  get '/game/overview' do
    if @current_user.null?
      redirect '/account/login'
    else
      slim :'game/overview'
    end
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

  post '/admin/login' do
    if BCrypt::Password.new(admin_pass) == params['adminCode']
      session[:admin] = true
    else
      flash[:errors] = [:wrong_code]
    end
    redirect back
  end
end
