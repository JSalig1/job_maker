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

use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == ENV['APPS_USER'] and password == ENV['APPS_PASS']
end

get "#{ENV['SUB_DIR']}/" do
  job_folder_helper = JobFolderHelper.new
  @job_folders = job_folder_helper.fetch_and_filter_jobs.sort_by(&:downcase)
  @producer_folders = job_folder_helper.fetch_producer_folders.sort_by(&:downcase)
  erb :index
end

get "#{ENV['SUB_DIR']}/new" do
  erb :new
end

post "#{ENV['SUB_DIR']}/job-folders" do
  flash[:notice] = NameValidator.validate request["folder_name"]
  redirect "#{ENV['SUB_DIR']}/"
end
