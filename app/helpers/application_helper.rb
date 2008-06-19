module ApplicationHelper

  def comment_display_url(comment)
    # TODO perhaps change this to comment.user.url
    comment.user_id.blank? ? comment.author_url : user_path(comment.user) 
  end

end