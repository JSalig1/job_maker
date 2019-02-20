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

  def compose(request)
    send(request, recipients)
  end

  private

  def send(request, recipients)

    body_text = format(request)

    Mail.deliver do
      to      recipients.join(", ")
      from    "1stAveMachine <do-not-reply@1stavemachine.com>"
      subject "New Job Folder | #{request["folder_name"]}"

      text_part do
        body body_text
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body body_text
      end
    end
  end

  def format(request)

    shoot_dates = []
    request.params.each do |key, value|
      if key.start_with? "shoot_date"
        shoot_dates << Date.parse(value).strftime("%m/%d/%Y")
      elsif key == "Ship Date"
        request.params.update( { "Ship Date" => Date.parse(value).strftime("%B %d, %Y") } )
      end
    end

    details = request.params.reject { |key, value| key.include? "_" }

    details.merge!("Shoot Dates" => shoot_dates*",  ")

    formatted_text = "Job Folder <strong>#{request["folder_name"]}</strong> " +
                     "has been added to the server.<br><br>"
    details.each { |key, value| formatted_text += " <strong>• #{key}:</strong> #{value}<br>" }
    return formatted_text
  end

end
