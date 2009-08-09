class User < ActiveRecord::Base

  acts_as_authentic

  is_paranoid

  validates_presence_of :first_name

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