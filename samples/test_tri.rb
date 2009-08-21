# tri.rb ruby-processing
load_library 'context_free'

def setup_the_triangle
        @triangle = ContextFree.define do
                rule :start do
                       legs :hue => 1, :saturation => 1, :brightness => 1
                end
                rule :legs do
			triangle :size => 0.99
                        circle :size => 0.99      
                 end
        end
end
                
def setup
        size 600, 600
        setup_the_triangle
        no_stroke
        color_mode HSB, 1.0
        smooth
        draw_it
        save_frame("tri.png")
end


def draw
        # Do nothing.
end


def draw_it
        background 1.0
        @triangle.render :start, :size => height/7,  :stop_size => 0.8,
        :start_x => width/2, :start_y => height/2 
end


def mouse_clicked
        draw_it
end
