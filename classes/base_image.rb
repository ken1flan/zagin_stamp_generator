class BaseImage
  attr_accessor :id, :name, :textbox_x, :textbox_y, :textbox_w, :textbox_h, :textbox_angle

  def initialize(id: nil, name: nil, textbox_x: 0, textbox_y: 0, textbox_w: 300, textbox_h: 300, textbox_angle: 0 )
    self.id = id
    self.name = name
    self.textbox_x = textbox_x
    self.textbox_y = textbox_y
    self.textbox_w = textbox_w
    self.textbox_h = textbox_h
    self.textbox_angle = textbox_angle
  end
end
