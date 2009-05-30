load_library 'context_free'

def setup_the_map
  
  @map = context_free do
    @shrink = 0.985
    
    rule :map do
      square
      split do
        wall :size => 1
        rewind
        wall :rotation => 180
      end
    end
    
    rule :wall do
      wall :y => 0.95, :rotation => 1, :size => @shrink
    end
    
    rule :wall do
      square
      wall :y => 0.95, :rotation => -1, :size => @shrink
    end
    
    rule :wall, 0.09 do
      square
      split do
        wall :y => 0.95, :rotation => 90, :size => @shrink
        rewind
        wall :y => 0.95, :rotation => -90, :size => @shrink
      end
    end
    
    rule :wall, 0.005 do
      split do
        wall :y => 0.97, :rotation => 90, :size => 1.5
        rewind
        wall :y => 0.97, :rotation => 90, :size => 1.5
      end
    end
  end
end


def setup
  size(600, 600)
  setup_the_map
  no_stroke
  smooth
  frame_rate 1
  the_color = [0.1, 0.1, 0.5]
  @map.setup :start_x => width/2, :start_y => height/2, :size => height/90, 
             :color => the_color, :stop_size => 0.01
  draw_it
end

def draw_the_background
  color_mode RGB, 1
  background 0.9, 0.8, 0.7
end

def draw_it
  Kernel::srand(@srand) if @srand
  draw_the_background
  @map.render :map
end

def mouse_clicked
  draw_it
end