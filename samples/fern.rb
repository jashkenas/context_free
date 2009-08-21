load_library 'context_free'

def setup_the_fern
  
  @fern = ContextFree.define do
    
    rule :start do
      fern :rotation => 50, :hue => 0.8
    end
    
    rule :fern do
      circle :size => 0.75, :rotation => -10
      split do
        fern :size => 0.92, :y => -2, :rotation => -5, :hue => 0.85
        rewind
        fern :size => 0.5, :y => -2, :rotation => 90
        rewind                                  
        fern :size => 0.5, :y => -2, :rotation => -90
      end
    end
    
  end
end

def setup
  size 600, 600
  setup_the_fern
  no_stroke
  color_mode HSB, 1.0
  smooth
  draw_it
end

def draw
  # Do nothing.
end

def draw_it
  background 0.33, 0.25, 0.2
  @fern.render :start, :size => height/23, :color => [0.35, 0.4, 0.9, 0.55], :stop_size => 1,
                       :start_x => width/2.5, :start_y => height/1.285
end

def mouse_clicked
  draw_it
end
