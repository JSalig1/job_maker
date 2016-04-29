require 'sinatra'
require 'sinatra/flash'
require 'dotenv'
require 'pathname'
require 'net/ssh'
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
  job_folder_helper = JobFolderHelper.new
  @job_folders = job_folder_helper.fetch_and_filter_jobs.sort_by(&:downcase)
  @producer_folders = job_folder_helper.fetch_producer_folders.sort_by(&:downcase)
  erb :index
end

get "#{ENV['SUB_DIR']}/new" do
  protected!
  erb :new
end

post "#{ENV['SUB_DIR']}/job-folders" do
  flash[:notice] = NameValidator.validate request["folder_name"]
  redirect "#{ENV['SUB_DIR']}/"
end
