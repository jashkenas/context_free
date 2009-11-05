# levy.rb ruby-processing NB: :alpha is not implemented in vanilla ruby-processing
load_library 'context_free'

def setup_the_levy
  @levy = ContextFree.define do
    rule :start do
      levy :brightness => 0.9
    end
    rule :levy do
      square :alpha => 0.1
      split do
        levy  :size => 1/Math.sqrt(2), :rotation => -45, :x => 0.5, :brightness => 0.9 
        rewind
        levy  :size => 1/Math.sqrt(2), :rotation => 45, :x => 0.5, :brightness => 0.9 
        rewind
      end
    end
  end
end


def setup
  size 400, 400
  setup_the_levy
  smooth
  draw_it
  save_frame("levy.png")
end


def draw
  # Do nothing.
end


def draw_it
  background 255
  @levy.render :start, :size => 250,  :stop_size => 2,
        :start_x => width/4, :start_y => height/2
end
