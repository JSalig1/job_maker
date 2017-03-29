class Mailer

  attr_reader :recipients

  def initialize

    @recipients = ENV['RECIPIENTS'].split(',')

    Mail.defaults do
      delivery_method :smtp, {
        port:         587,
        address:      "smtp.gmail.com",
        user_name:    ENV['USER_NAME'],
        password:     ENV['PASSWORD'],
        authentication:    "plain",
        enable_starttls_auto:    true
      }
    end
  end

  def compose(folder_name)
    send(folder_name, recipients)
  end

  private

  def send(folder_name, recipients)
    Mail.deliver do
      to      recipients.join(", ")
      from    "1stAveMachine <do-not-reply@1stavemachine.com>"
      subject "New Job Folder | #{folder_name}"

      text_part do
        body "Job folder #{folder_name} has been created on the server."
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body "#{folder_name} has been created on the Server"
      end
    end
  end

end
