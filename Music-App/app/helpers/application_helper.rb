module ApplicationHelper
  def auth_input
    html = <<-HTML
      <input type="hidden" name="authenticity_token"
        value=#{form_authenticity_token}>
    HTML

    html.html_safe
  end

  def request_input(request)
    html = <<-HTML
      <input type="hidden" name="_method" value=#{h(request)}>
    HTML

    html.html_safe
  end
end
