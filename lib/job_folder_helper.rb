class JobFolderHelper

  def initialize
    @protected = ENV['PROTECTED'].split(",")
    @job_folders = Pathname.new(ENV['JOBS_FOLDER_PATH']).children
    @producer_folders = Pathname.new(ENV['PRODUCERS_FOLDER_PATH']).children
  end

  def fetch_and_filter_jobs
    folders = @job_folders.keep_if(&:directory?).map!(&presentify)
    folders.delete_if(&protected_directory)
  end

  def fetch_producer_folders
    @producer_folders.keep_if(&:directory?).map!(&presentify)
  end

  def fetch_all_from_jobs
    @job_folders.map!(&presentify)
  end

  private

  def presentify
    Proc.new { |path| path.basename.to_s }
  end

  def protected_directory
    Proc.new { |path| @protected.include? path }
  end

end
