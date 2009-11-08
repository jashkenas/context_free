# dragon.rb ruby-processing NB: :alpha is not implemented in vanilla ruby-processing
load_library 'context_free'

def setup_the_dragon
  @dragon = ContextFree.define do
    rule :start do
      dragon :alpha => 1
    end
    rule :dragon do
      square :hue => 0, :brightness => 1, :saturation => 1, :alpha => 0.01
      split do
        dragon :size => 1/Math.sqrt(2), :rotation => -45, :x => 0.25, :y => 0.25 
        rewind
        dragon :size => 1/Math.sqrt(2), :rotation => 135, :x => 0.25, :y => 0.25
        rewind
      end
    end
  end
end


def setup
  size 600, 400
  setup_the_dragon
  smooth
  draw_it
  save_frame("dragon.png")
end


def draw
  # Do nothing.
end


def draw_it
  background 255
  @dragon.render :start, :size => width*0.8, :stop_size => 2,
        :start_x => width/3, :start_y => height/3
end
