module ApplicationHelper

  def logo
     image_tag "images.jpg", :alt => "JZ Sample App", :class => "round"
  end

  def myhelper
    base_title = "Ruby on Rails Tutorial Sample App"
    if@title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
end


end
