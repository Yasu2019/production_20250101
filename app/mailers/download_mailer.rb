# frozen_string_literal: true
# comment
class DownloadMailer < ApplicationMailer
  default from: 'mitsui.seimitsu.iatf16949@gmail.com'

  # app/mailers/download_mailer.rb
  def send_download_password(email, password, token)
    @password = password
    @token = token
    mail(to: email, subject: 'Your Download Password')
  end
end
