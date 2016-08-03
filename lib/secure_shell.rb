class SecureShell
  def initialize

    @session = Net::SSH.start(
      ENV['SERVER_HOST'],
      ENV['SERVER_USER'],
      password: ENV['SERVER_PASSWORD']
    )

  end

  def create_job_folder(folder_name)
    job_folder_command = generate_copy_to_job_folder + folder_name
    producer_folder_command = generate_copy_to_producer_folder + folder_name
    @session.exec!(job_folder_command)
    @session.exec!(producer_folder_command)
    @session.close
  end

  def restart_the_server
    @session.exec("shutdown -r now")
    @session.close
    "Restart initialized."
  end

  def restart_cifs
    @session.exec!("service samba_server stop")
    @session.exec!("service ix-pre-samba restart")
    @session.exec!("service samba_server start")
    @session.exec!("service ix-post-samba restart")
    @session.exec!("service mdnsd restart")
    @session.close
    "CIFS restart initialized."
  end

  private

  def generate_copy_to_job_folder
    "cp -a #{ENV['JOB_TEMPLATE_PATH']} #{ENV['JOB_TARGET_PATH']}/"
  end

  def generate_copy_to_producer_folder
    "cp -a #{ENV['PRODUCER_TEMPLATE_PATH']} #{ENV['PRODUCER_TARGET_PATH']}/"
  end
end
