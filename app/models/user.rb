class User < ActiveRecord::Base

  acts_as_authentic

  validates_presence_of :first_name

  is_gravtastic :with => :email, :rating => 'R', :size => 30

  def to_s
    first_name
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def activate!
    self.update_attributes(:activated_at => Time.now)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
end