class NameValidator

  def self.validate(request)
    if request["folder_name"] =~ /(?!.*__.*)[a-zA-Z0-9]+_[a-zA-Z0-9_]+[a-zA-Z0-9]/
      check_for_existing(request)
    else
      "folder name was not valid"
    end
  end

  private

  def self.check_for_existing(request)
    job_folders = JobFolderHelper.new.fetch_all_from_jobs.map!(&:downcase)
    if job_folders.include?(request["folder_name"].downcase)
      "A job folder by that name either already exists or is not allowed"
    else
      server_shell = SecureShell.new( ENV['SERVER_HOST'] )
      server_shell.create_job_folder( request["folder_name"] )
      server_shell = SecureShell.new( ENV['CODEX_HOST'] )
      server_shell.create_codex_folder( request["folder_name"] )
      mailer = Mailer.new
      mailer.compose(request)
      "Job folder created"
    end
  end
end
