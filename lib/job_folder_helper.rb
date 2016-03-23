class JobFolderHelper
  def self.fetch_job_folders
    Pathname.new(ENV['JOBS_FOLDER_PATH']).children.map(&:basename)
  end
end
