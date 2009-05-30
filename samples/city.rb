load_library 'context_free'

def setup_the_city
  @city = context_free do
    rule :whole do
      split do
        quad :x => -0.25, :y => -0.25
        rewind
        quad :x => 0.25, :y => -0.25
        rewind
        quad :x => 0.25, :y => 0.25
        rewind
        quad :x => -0.25, :y => 0.25
      end
    end
    
    rule :quad do
      fill :size => 0.85
    end
    
    rule :quad, 5 do
      whole :size => 0.5, :rotation => rand(4), :hue => rand(2), :brightness => rand(3)
    end
    
    rule :quad, 0.1 do
      # Do nothing
    end
    
    rule :fill do
      square
    end
  end
end


def setup
  size 600, 600
  setup_the_city
  smooth
  @background = color 255, 255, 255
  the_color = [0.1, 0.1, 0.1]
  @city.setup :start_x => width/2, :start_y => height/2, :size => height/3, :color => the_color
  draw_it
end

def draw
  # Do nothing
end

def draw_it
  background @background
  @city.render :whole
end

def mouse_clicked
  draw_it
end