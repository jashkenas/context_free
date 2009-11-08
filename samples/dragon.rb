# contributed by monkstone

load_library 'context_free'

def setup_the_dragon
  @dragon = ContextFree.define do

    rule :start do
      dragon :alpha => 1
    end

    rule :dragon do
      square :hue => 0, :brightness => 0, :saturation => 1, :alpha => 0.02
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
  size 800, 500
  setup_the_dragon
  smooth
  draw_it
end

def draw
  # Do nothing.
end

def draw_it
  background 255
  @dragon.render :start, :size => width*0.8,  :stop_size => 2,
                         :start_x => width/3, :start_y => height/3.5
end
