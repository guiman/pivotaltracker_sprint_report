class ConfigurationApp < Sinatra::Base
  get '/configuration' do
    erb :configuration
  end

  get '/configuration/pivotal' do
    @configuration = Pivotal::Configuration::Repository.get(:pivotal)

    erb :pivotal
  end

  post '/configuration/pivotal' do
    @configuration = Pivotal::Configuration::Pivotal.new(token: params['token'],
                                                         project: params['project_id'])
    if @configuration.valid?
      @configuration.save!

      redirect '/'
    else
      erb :pivotal
    end
  end
end
