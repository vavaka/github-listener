class HookMailer < ActionMailer::Base
  default from: "vavaka.mailer@gmail.com"

  def hook_email(options)
    @payload = options[:payload]

    if options[:attachments]
        options[:attachments].each do |a|
          attachments[a[:name]] = a[:data]
        end
    end

    mail(:to => "vavaka@gmail.com", :subject => "hook fired")
  end
end
