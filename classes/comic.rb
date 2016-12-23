require_relative 'component_image'
require_relative 'text_image'
require_relative 'stamp'

class Comic
  attr_accessor :title

  MARGIN = 5
  TITLE_HEIGHT = 50
  PANEL_SIZE = Stamp::SIZES[:Middle]
  TITLE_SIZE = {
    width: PANEL_SIZE[:width] - MARGIN * 2,
    height: TITLE_HEIGHT - MARGIN * 2
  }
  PANEL_NUM = 4
  BORDER_COLOR = "#505050"

  def initialize(title: nil, panel_attributes: {})
    @title = title
    @panel_attributes = panel_attributes
  end

  def title_image
    @title_image ||= TextImage.new(text: title, width: TITLE_SIZE[:width], height: TITLE_SIZE[:height]).image
  end

  def panels
    return @panels if @panels

    @panels = {}
    @panel_attributes.each do |id, params|
      stamp = Stamp.create_by_id(params[:image_name])
      stamp.mirror_copy = params[:mirror_copy] == 'yes'
      stamp.text = params[:text]
      stamp.text_color = params[:text_color]
      stamp.font_name = params[:font_name]
      stamp.pattern_name = params[:pattern]
      @panels[id] = stamp
    end

    @panels
  end

  def base_image
    base_image = MiniMagick::Image.open(File.expand_path('../../images/source.png', __FILE__))
    base_image.extent "#{PANEL_SIZE[:width]}x#{MARGIN + TITLE_HEIGHT + MARGIN + (PANEL_SIZE[:height] + 3) * 4}"
    base_image.combine_options do |c|
      c.fill BORDER_COLOR
      c.draw "rectangle 0, 45, 300, 50"
      c.draw "rectangle 0, #{TITLE_HEIGHT}, #{PANEL_SIZE[:width]}, #{TITLE_HEIGHT + PANEL_SIZE[:height] * 4 + MARGIN * 3}"
    end
    base_image
  end

  def image
    return @image if @image

    @image = base_image

    @image = @image.composite(title_image) do |c|
      c.compose "Over"
      c.geometry "+#{MARGIN}+#{MARGIN}"
      c.gravity 'NorthWest'
    end

    panels.each do |id, panel|
      panel_image = panel.composite.resize "#{PANEL_SIZE[:width]}x#{PANEL_SIZE[:height]}"
      @image = @image.composite(panel_image) do |c|
        c.compose "Over"
        c.geometry "+0+#{TITLE_HEIGHT + (PANEL_SIZE[:height] + MARGIN) * (id.to_i - 1)}"
        c.gravity 'NorthWest'
      end
    end
    @image
  end
end
