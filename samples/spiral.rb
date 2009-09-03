# Contributed by Monkstone.

load_library 'context_free'

def setup_the_spiral
  @spiral = ContextFree.define do
    
    rule :start do
       split do
       star :rotation => 240
       rewind
       star :rotation => 120
       rewind
       star :rotation => 0
       end
    end
    
    rule :base do
       triangle :hue => 0.5
       base :rotation =>  3, :size => 0.98, :x => 0.09, :brightness => 1.01
    end
    
    rule :star do
       split do             
       base :brightness => 0.8, :rotation => 80
       rewind
       base :brightness => 0.8, :rotation => 40
       rewind
       base :brightness => 0.8, :rotation => 0
       end
    end
    
  end
end
 
def setup
  size 600, 600
  setup_the_spiral
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
  @spiral.render :start, :size => height/5, :stop_size => 1,
                         :color => [0.35, 0.4, 0.9, 0.25], 
                         :start_x => width/2, :start_y => height/2
end