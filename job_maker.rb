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

get "#{ENV['SUB_DIR']}/" do
  @job_folders = JobFolderHelper.new.fetch_for_presentation.sort_by(&:downcase)
  erb :index
end

get "#{ENV['SUB_DIR']}/new" do
  erb :new
end

post "#{ENV['SUB_DIR']}/job-folders" do
  flash[:notice] = NameValidator.validate request["folder_name"]
  redirect "#{ENV['SUB_DIR']}/"
end
