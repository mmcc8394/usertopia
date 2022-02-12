module ApplicationHelper
  def navigation_bar
    in_admin_namespace? && logged_in? ? 'logged_in_navigation' : 'default_navigation'
  end

  def in_admin_namespace?
    controller.class.name.split("::").first == 'Admin'
  end

  def contact_us_page?
    action?('contacts', 'new')
  end

  def action?(controller, action)
    params[:controller] == controller && params[:action] == action
  end

  #
  # The following three functions are purely to make the HTML look more
  # readable. Not essential but makes for a cleaner HTML page.
  #
  def page_title(title)
    content_for(:page_title) { remove_extra_white_space(title) }
  end

  def meta_description(description)
    content_for(:meta_description) { remove_extra_white_space(description) }
  end

  def remove_extra_white_space(str)
    str.gsub(/\n/, " ").gsub(/\s+/, " ")
  end
end
