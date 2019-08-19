$domain_name = "192.168.2.222:9292"

class App < Sinatra::Base
  # Password for admin page
  # killerpass123 admin_pass = "$2a$12$n6mUrm6FG1nT42/6CsYgpu7UXXGvOqyVrPmvfhoR2CJCoBO5yq452"

  superuser_pass = "$2a$12$DTlPftuCRgLIyRuqWiixvu4wk8C36YX21Kjyqjk0Ef8s0kkI8njAa"

  enable :sessions
  set :bind, '0.0.0.0'
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
    redirect '/'
  end

  before do
    # Compile scss to css
    scss_files = Dir["./views/scss/**/*.scss"]
    scss_files.each do |f|
      scss = SassC::Engine.new File.read(f), style: :compressed
      scss = scss.render
      new_path = f.split "scss"
      new_path = "./public/css#{new_path[1]}css"
      File.open new_path, 'w' do |file|
        file.write scss
      end
    end

    if session[:user_id]
      @current_user = User.get id: session[:user_id]
    else
      @current_user = User.null_user
    end
    if !flash[:errors] 
      flash.now[:errors] = []
    end
    if !flash[:msg] 
      flash.now[:msg] = []
    end
  end

  get '/' do
    if @current_user.null?
      slim :'account/login'
    else
      redirect '/game/overview'
    end
  end

  get '/account/login' do
    if @current_user.null?
      slim :'account/login'
    else
      redirect '/game/overview'
    end
  end

  get '/account/new' do
    slim :'account/new'
  end

  get '/account/resetpw' do
    slim :'account/resetpw'
  end

  get '/account/newpw' do
    @token = params[:token]
    @email = params[:email]
    @validated = PasswordReset.validate_token @token, @email
    # TODO: Create post handling for this
    slim :'account/newpw'
  end

  get '/admin/overview' do
    if session[:admin] || session[:superuser]
      @is_admin = true
      @users = User.select(order_by: 'class, first_name').map { |x| User.new x  }
      @target_chain = User.get_target_chain
    else
      @is_admin = false
    end


    slim :'admin/overview'
  end

  get '/admin/control_panel' do
    if session[:superuser]
      @is_superuser = true
      @gamestate = GameState.get_state
    else
      @is_superuser = false
    end

    slim :'admin/control_panel'
  end

  get '/admin/userData' do
    if !(session[:admin] || session[:superuser])
      halt 200
    end
    # Assure that we aren't getting sql injected
    if params[:column] == "score" || params[:column] == "target"
      col = "first_name"
    else
      col = Database.quote_ident params[:column]
    end
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
      row["alive"] = row["alive"] ? "Levande" : "Död"
    end

    # Some bonus sorting for score and target
    if params[:column] == "score" && order == "ASC"
      result = result.sort { |a, b| a["score"] <=> b["score"] }
    elsif params[:column] == "score" && order == "DESC"
      result = result.sort { |a, b| b["score"] <=> a["score"] }
    elsif params[:column] == "target" && order == "ASC"
      result = result.sort { |a, b| a["target_name"] <=> b["target_name"] }
    elsif params[:column] == "target" && order == "DESC"
      result = result.sort { |a, b| b["target_name"] <=> a["target_name"] }
    end
    result.to_json
  end

  get '/game/overview' do
    if @current_user.null?
      redirect '/account/login'
    else
      if GameState.pregame?
        slim :'/pregame'
      else
        @high_score_list = User.get_high_score_list
        slim :'game/overview'
      end
    end
  end

  get '/game/rules' do
    if @current_user.null?
      redirect '/account/login'
    else
      slim :'game/rules'
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

  post '/account/resetpw' do
    user = User.get email: params[:email]
    if user.null?
      flash[:errors] = [:wrong_email]
      redirect back
    else
      PasswordReset.create_password_reset user.get_id
      flash[:msg] = [:pw_reset]
      redirect back
    end
  end

  post '/account/setnewpw' do
    token = params[:token]
    email = params[:email]
    new_pw = params[:password]
    new_pw_conf = params[:passwordConfirm]
    errors = User.validate_new_password new_pw, new_pw_conf
    if errors.empty? && PasswordReset.validate_token(token, email)
      flash[:msg] = [:new_pw_set]
      PasswordReset.set_new_password new_pw, token, email
    else
      flash[:errors] = errors
    end
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

  post '/superuser/login' do
    if BCrypt::Password.new(superuser_pass) == params['superuserCode']
      session[:superuser] = true
    else
      flash[:errors] = [:wrong_code]
    end
    redirect back
  end

  post '/superuser/setGameState' do
    if session[:superuser]
      state = params[:state].to_i
      if state == 0
        GameState.set_pregame
      elsif state == 1
        GameState.set_running
      elsif state == 2
        GameState.set_postgame
      end
      GameState.get_state_number.to_s
    else
      -1.to_s
    end
  end

  not_found do
    status 404
    slim :'404', layout: false
  end
end
