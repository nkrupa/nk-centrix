module ApplicationHelper

  def render_generated_image(image)
    content_tag :img, "", src: "data:image/png;base64,#{image.base64}"
  end
end
