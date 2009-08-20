# creature.rb ruby-processing
load_library 'context_free'

def setup_the_creature
        @creature = ContextFree.define do
                rule :start do
                        rot = 0
                        split do
                                11.times do            # 11 times increment rotation by 30 degrees
                                        legs :rotation => rot
                                        rot += 30
                                        rewind           # rewind context
                                end
                                legs :rotation => 360
                        end
                end
                rule :legs do
                        circle :hue => 0.15, :saturation => 0.5, :brightness => 1.0, :color => [0.95, 0.15]
                        legs :y => 0.1, :size => 0.965
                end
                rule :legs, 0.01 do
                        circle
                        split do
                        legs :rotation => 3 
                        rewind
                        legs :rotation => -3
                        end
                end
        end
end
                
def setup
        size 600, 600
        setup_the_creature
        no_stroke
        color_mode HSB, 1.0
        smooth
        draw_it
        save_frame("creature.png")
end


def draw
        # Do nothing.
end


def draw_it
        background -1.0
        @creature.render :start, :size => height/5, :stop_size => 0.8,
        :start_x => width/2, :start_y => height/3,  :color => [0.75, 0.1, 0.9]
end


def mouse_clicked
        draw_it
end
