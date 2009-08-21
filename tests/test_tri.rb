# contributed by monkstone

load_library 'context_free'

def setup
  @triangle = ContextFree.define do
    rule :tri do
      circle      
      triangle :brightness => 0
    end
  end
  
  size 200, 200
  color_mode HSB, 1.0
  smooth
  draw_it
  # save_frame("tri.png")
end

def draw_it
  background 1.0
  @triangle.render :tri, :size => height/2
end

def draw
  # Do nothing.
end

def mouse_clicked
  draw_it
end
