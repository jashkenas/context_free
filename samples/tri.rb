# dark_star.rb ruby-processing
load_library 'context_free'

def setup_the_sun
        @sun = ContextFree.define do
                rule :start do
                        rot = 0
                        split do
                                3.times do
                                        legs :rotation => rot
                                        rot += 80
                                        rewind
                                end
                                legs :rotation => 360
                        end
                end
                rule :legs do
			triangle                       
                        legs :rotation => 1, :y => 0.1,
                        :size => 0.965, :color => [0.22, 0.15], :alpha => 0.5
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
        save_frame("sun.png")
end


def draw
        # Do nothing.
end


def draw_it
        background 1.0
        @sun.render :start, :size => height/7,  :stop_size => 0.8,
        :start_x => width/2, :start_y => height/2 
end


def mouse_clicked
        draw_it
end
