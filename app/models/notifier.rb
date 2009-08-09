class Notifier < ActionMailer::Base
  def password_reset_instructions(user)
    setup(user)
    subject      "Password Reset Instructions"
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def activation_instructions(user)
    setup(user)
    subject       "Activation Instructions"
    body          :account_activation_url => activate_url(user.perishable_token)
  end

  def activation_confirmation(user)
    setup(user)
    subject       "Welcome to Bumble"
    body          :root_url => root_url
  end

  def new_comment_alert(comment)
    setup(comment.post.user)
    subject       "New comment on #{comment.post.title}"
    body          :comment => comment
  end

  protected

  def setup(user)
    recipients   user.email
    from         "Bumble <noreply@#{DOMAIN}>"
    subject      "Bumble Message"
    sent_on      Time.now
    body         :user => user
  end
end