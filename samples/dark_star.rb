# contributed by monkstone

load_library 'context_free'

def setup_the_sun
  @sun = ContextFree.define do

    rule :start do
      rot = 0
      split do
        12.times do
          legs :rotation => rot
          rot += 30
          rewind
        end
        legs :rotation => 360
      end
    end

    rule :legs do
      circle
      legs :rotation => 1, :y => 0.1,
      :size => 0.973, :color => [0.22, 0.15]
    end

  end
end

def setup
  size 600, 600
  setup_the_sun
  no_stroke
  color_mode HSB, 1.0
  smooth
  draw_it
  # save_frame("sun.png")
end

def draw
  # Do nothing.
end

def draw_it
  background 0.7
  @sun.render :start, :size => height/7,  :stop_size => 0.8,
  :start_x => width/2, :start_y => height/2
end

def mouse_clicked
  draw_it
end
