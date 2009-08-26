load_library 'context_free', 'control_panel'

attr_accessor :resolution

def setup_the_triangle
  
  @triangle = ContextFree.define do
    rule :tri do
      triangle :size => 0.5, :rotation => PI
      split do
        tri :size => 0.5, :y => -0.578, :x => 0, 
            :hue => 0.8, :saturation => 0.2, :brightness => 0.8
        rewind
        tri :size => 0.5, :y => 0.289, :x => -0.5, :hue => 0.2, 
            :saturation => 0.2, :brightness => 0.8
        rewind
        tri :size => 0.5, :y => 0.289, :x => 0.5, :hue => 0.2, 
            :saturation => 0.2, :brightness => 0.8
      end
    end
    
  end
end

def setup
  size 600, 600
  setup_the_triangle
  no_stroke
  color_mode HSB, 1.0
  smooth
  @resolution = 5
  control_panel do |p|
    p.slider :resolution, (2..50), 5
  end
end

def draw
  background 0.1
  @triangle.render :tri, :size => height/1.1, :color => [0, 0.5, 1], :stop_size => @resolution, :start_y => height/1.65
end
