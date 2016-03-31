class JobFolderHelper
  def self.fetch_job_folders
    Pathname.new(ENV['JOBS_FOLDER_PATH']).children.map!(&basename_to_s)
  end

  private

  def self.basename_to_s
    Proc.new { |path| path.basename.to_s }
  end
end
