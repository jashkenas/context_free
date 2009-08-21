load_library 'context_free'

def setup_the_vine
  
  @vine = ContextFree.define do
    
    shrink = 0.961
    
    rule :root do
      split do
        shoot :y => 1
        rewind
        shoot :rotation => 180
      end
    end
    
    rule :shoot do
      square
      shoot :y => 0.98, :rotation => 5, :size => shrink + rand * 0.05, :brightness => 0.990
    end
    
    rule :shoot, 0.02 do
      square
      split do
        shoot :rotation => 90
        rewind
        shoot :rotation => -90
      end
    end
    
  end
end

def setup
  size 700, 700
  setup_the_vine
  no_stroke
  color_mode HSB, 1.0
  smooth
  draw_it
end

def draw
  # Do nothing.
end

def draw_it
  background 0.75, 1.0, 0.15
  @vine.render :root, :size => height/75, :color => [0.75, 0.1, 0.9],
                     :start_x => width/2, :start_y => height/2
end

def mouse_clicked
  draw_it
end