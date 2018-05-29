class NameValidator

  def self.validate(folder_name)
    if folder_name =~ /(?!.*__.*)[a-zA-Z0-9]+_[a-zA-Z0-9_]+[a-zA-Z0-9]/
      check_for_existing(folder_name)
    else
      "folder name was not valid"
    end
  end

  private

  def self.check_for_existing(folder_name)
    job_folders = JobFolderHelper.new.fetch_all_from_jobs.map!(&:downcase)
    if job_folders.include?(folder_name.downcase)
      "A job folder by that name either already exists or is not allowed"
    else
      server_shell = SecureShell.new( ENV['SERVER_HOST'] )
      server_shell.create_job_folder(folder_name)
      server_shell = SecureShell.new( ENV['CODEX_HOST'] )
      server_shell.create_codex_folder(folder_name)
      mailer = Mailer.new
      mailer.compose(folder_name)
      "Job folder created"
    end
  end
end
