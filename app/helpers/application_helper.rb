module ApplicationHelper
  def markdown(text)
    text.blank? ? "" : sanitize(RDiscount.new(text).to_html, :tags => %w(a p pre code b strong em i strike ul ol li blockquote br))
  end

  def render_post(post, title = true)
    render :partial => "posts/types/#{post.class.to_s.downcase}.html.haml", :object => post, :locals => {:title => title}
  end

  def format_datetime_ago(time)
    if time > 5.days.ago
      formatted = time_ago_in_words(time).capitalize
      formatted.insert(0, 'Live in ') if time > Time.now
      formatted.insert(formatted.length, ' ago') if time < Time.now
    end

    content_tag :abbr, formatted || time.strftime('%d %b %y'), :title => time.iso8601, :class => 'published updated'
  end

  def page_title
    escape_once(strip_tags([DOMAIN, @page_title].compact.reject(&:blank?).join(' | ')))
  end

  def page_description
    escape_once((@page_description || 'The website of Andrew Nesbitt, a web developer from London. Expect to find posts and links about technology, the web, ruby, rails, html, css, jquery and random cat pictures.'))
  end

  def youtube_embed(link, width = 500, height = 300)
    link.gsub(/http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/) do
      youtube_id = $2
      content_tag :object, :width => width, :height => height, :data => "http://www.youtube.com/v/#{youtube_id}" do
        tag(:param, :name => 'movie', :value => "http://www.youtube.com/v/#{youtube_id}") +
        tag(:param, :name => 'allowFullScreen', :value => 'true') +
        tag(:param, :name => 'allowscriptaccess', :value => 'always') +
        tag(:embed, :src => "http://www.youtube.com/v/#{youtube_id}", :type => 'application/x-shockwave-flash', :allowscriptaccess => 'always', :allowfullscreen => 'true', :width => width, :height => height)
      end
    end
  end

  def spam_link_for(comment)
    if comment.approved?
      link_to 'Spam', reject_comment_path(comment)
    else
      link_to 'Approve', approve_comment_path(comment)
    end
  end
end