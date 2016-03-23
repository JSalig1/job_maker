require 'sinatra'
require 'dotenv'
require 'pathname'
require './lib/job_folder_helper'

Dotenv.load

get "#{ENV['SUB_DIR']}/" do
  @job_folders = JobFolderHelper.fetch_job_folders
  erb :index
end

get "#{ENV['SUB_DIR']}/new" do
  erb :new
end
