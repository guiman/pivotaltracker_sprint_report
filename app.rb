require 'sinatra/base'
require 'redcarpet'
require_relative 'initialize'

class PivotalApp < Sinatra::Base
  configure do
    set :root, PivotalApp.root
    set :public_folder, File.dirname(__FILE__) + '/static'
    set :server, :thin
    set :show_exceptions, false
  end

  get '/' do
    erb :index
  end

  get '/sprint-review' do
    erb :sprint_review_form
  end

  post '/sprint-review' do
    configuration = Pivotal::Configuration::Pivotal.new(
      token: params['configuration']['access_token'],
      project: params['configuration']['project'])

    pivotal_operations = Pivotal::Operations.new(configuration: configuration)
    @sprint_review = Pivotal::SprintReview.from_hash(
      params: params['sprint_review'], pivotal_operations: pivotal_operations)

    if @sprint_review.valid?
      erb :sprint_review
    else
      redirect '/sprint-review'
    end
  end

  error do
    @error_information = "Please contact support."
    erb :error
  end
end
