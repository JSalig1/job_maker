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
    job_folders = JobFolderHelper.fetch_job_folders.map!(&:downcase)
    if job_folders.include?(folder_name.downcase)
      "a job folder by that name already exists"
    else
      server_shell = SecureShell.new
      server_shell.create_job_folder(folder_name)
      "Job folder created"
    end
  end
end
