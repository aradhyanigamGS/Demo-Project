# include Rails.application.routes.url_helpers
class ProjectMailer < ApplicationMailer
  default from: 'uthakkar@grepruby.in'
  layout 'mailer'

  def invite_email(email:,project:)
    @email = email
    @project = project
    puts "****************************************************************"
    puts @email
    puts @project
    puts "****************************************************************"
    # @project = Project.friendly.find_by_slug(params[:slug])
    mail(to: @email, subject: 'Invite User')
  end

end