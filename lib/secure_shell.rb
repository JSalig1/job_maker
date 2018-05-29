class SecureShell
  def initialize(host)

    Net::SSH::Transport::Algorithms::ALGORITHMS[:encryption] = %w(
      aes128-cbc 3des-cbc blowfish-cbc cast128-cbc
      aes192-cbc aes256-cbc arcfour128 arcfour256 arcfour
      aes128-ctr aes192-ctr aes256-ctr cast128-ctr blowfish-ctr 3des-ctr
    )

    @session = Net::SSH.start(
      host,
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

  def create_codex_folder(folder_name)
    codex_folder_command = generate_copy_to_codex_folder + folder_name
    @session.exec!(codex_folder_command)
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

  def generate_copy_to_codex_folder
    "cp -a #{ENV['CODEX_TEMPLATE_PATH']} #{ENV['CODEX_TARGET_PATH']}/"
  end

  def generate_copy_to_job_folder
    "cp -a #{ENV['JOB_TEMPLATE_PATH']} #{ENV['JOB_TARGET_PATH']}/"
  end

  def generate_copy_to_producer_folder
    "cp -a #{ENV['PRODUCER_TEMPLATE_PATH']} #{ENV['PRODUCER_TARGET_PATH']}/"
  end
end
