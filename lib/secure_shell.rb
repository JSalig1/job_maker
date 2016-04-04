class SecureShell
  def initialize

    @session = Net::SSH.start(
      ENV['SERVER_HOST'],
      ENV['SERVER_USER'],
      password: ENV['SERVER_PASSWORD']
    )

  end

  def create_job_folder(folder_name)
    command = generate_copy_to_job_folder + folder_name
    puts command
    @session.exec!(command)
    @session.close
  end

  private

  def generate_copy_to_job_folder
    "cp -a #{ENV['JOB_TEMPLATE_PATH']} #{ENV['JOB_TARGET_PATH']}/"
  end
end
