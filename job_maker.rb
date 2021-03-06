require 'sinatra'
require 'sinatra/flash'
require 'dotenv'
require 'pathname'
require 'net/ssh'
require 'mail'
require './lib/mailer'
require './lib/job_folder_helper'
require './lib/name_validator'
require './lib/secure_shell'

Dotenv.load

enable :sessions
set :session_secret, ENV['SECRET']

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and
    @auth.basic? and
    @auth.credentials and
    @auth.credentials == [ ENV['APPS_USER'], ENV['APPS_PASS'] ]
  end
end

get "#{ENV['SUB_DIR']}/" do
  redirect to "#{ENV['SUB_DIR']}/2019"
end

get "/server-restart" do
  protected!
  erb :server_restart, layout: :layout_server_restart
end

get "#{ENV['SUB_DIR']}/:year" do
  folder_helper = JobFolderHelper.new
  if folder_helper.valid_year?(params[:year])
    @year = params[:year]
    @years = folder_helper.years
    @job_folders = folder_helper.fetch_and_filter_jobs.sort_by(&:downcase)
    @producer_folders = folder_helper.fetch_producer_folders_by(@year).sort_by(&:downcase)
    erb :index
  else
    redirect to "/2019"
  end
end

get "#{ENV['SUB_DIR']}/job_folders/new" do
  protected!
  erb :new
end

post "#{ENV['SUB_DIR']}/job-folders" do
  flash[:notice] = NameValidator.validate request
  redirect "#{ENV['SUB_DIR']}/2019"
end

post "/server-restart" do
  server_shell = SecureShell.new
  flash[:notice] = server_shell.restart_the_server
  redirect "/server-restart"
end

post "/cifs-restart" do
  server_shell = SecureShell.new
  flash[:notice] = server_shell.restart_cifs
  redirect "/server-restart"
end
