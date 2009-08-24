# TODO: Fix the triangle primitive to not have any points going out of the unit
# circle.

load_library 'context_free'

Y_TOP = (4 - (5 * (Math.sqrt(3))))/8
Y_BOT = (4 - Math.sqrt(3))/8

def setup_the_triangle
  
  @triangle = ContextFree.define do
    
    rule :tri do
      triangle :size => 1.0, :set_brightness => 1
      triangle :size => 0.51, :set_brightness => 0, :rotation => PI
      split do
        tri :size => 0.5, :y => -0.577, :x => 0
        rewind
        tri :size => 0.5, :y => 0.285, :x => -0.51
        rewind
        tri :size => 0.5, :y => 0.285, :x => 0.51
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
  draw_it
end

def draw
  # Do nothing.
end

def draw_it
  background 0.1
  @triangle.render :tri, :size => height/1.2, :color => [0, 0, 0], :stop_size => 5, :start_y => height/1.65
end

def mouse_clicked
  draw_it
end
