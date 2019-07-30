#TODO: USE KILLS TABLE
class App < Sinatra::Base
  # Password for admin page
  # killerpass123
  admin_pass = "$2a$12$n6mUrm6FG1nT42/6CsYgpu7UXXGvOqyVrPmvfhoR2CJCoBO5yq452"

  enable :sessions
  register Sinatra::Flash
  set :public_folder, '/home/vdesktop/github/nti-killer-games/public'

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
      @target_chain = User.get_target_chain
    else
      @is_admin = false
    end


    slim :'admin/overview'
  end

  get '/admin/userData' do
    # Assure that we aren't getting sql injected
    col = Database.quote_ident params[:column]
    order = params[:order]
    if order == "desc"
      order = "DESC"
    else
      order = "ASC"
    end

    result = Database.exec "SELECT * FROM users ORDER BY #{col} #{order};"
    result.each do |row|
      target = User.get id: row["target_id"]
      user = User.new row
      row["target_name"] = target.get_first_name + " " + target.get_last_name
      row["score"] = user.get_score
    end
    result.to_json
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

  post '/account/die' do
    @current_user.die
    redirect back
  end

  post '/admin/login' do
    if BCrypt::Password.new(admin_pass) == params['adminCode']
      session[:admin] = true
    else
      flash[:errors] = [:wrong_code]
    end
    redirect back
  end

  not_found do
    status 404
    slim :'404', layout: false
  end
end
