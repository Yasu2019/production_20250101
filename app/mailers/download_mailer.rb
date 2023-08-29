class DownloadMailer < ApplicationMailer
  default from: 'mitsui.seimitsu.iatf16949@gmail.com'

  def send_download_password(email, password)
    @password = password
    mail(to: email, subject: 'Your Download Password')
  end
end
