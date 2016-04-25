class JobFolderHelper

  def initialize
    @protected = ENV['PROTECTED']
  end

  def fetch_for_presentation
    job_folders = fetch_job_folders.keep_if(&:directory?)
    job_folders.map!(&presentify).sort_by(&:downcase)
    job_folders.delete_if(&protected_directory)
  end

  def fetch_for_validations
    fetch_job_folders.map!(&presentify).map!(&:downcase)
  end

  private

  def fetch_job_folders
    Pathname.new(ENV['JOBS_FOLDER_PATH']).children
  end

  def presentify
    Proc.new { |path| path.basename.to_s }
  end

  def protected_directory
    Proc.new { |path| @protected.include? path }
  end

end
