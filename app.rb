class App < Sinatra::Base
  get '/' do
    slim :index
  end

  get '/words' do
    ap (CodeWord.select_all)
    "kek"
  end
end
