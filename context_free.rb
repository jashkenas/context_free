# A first stab at doing a Context-Free, 
# domain-specific language for Ruby-Processing.
# The next draft will probably break the rules 
# and rulesets out into actual classes of their own.

module Processing
  
  class ContextFree
    attr_accessor :rules, :app
    STOP_SIZE = 1.5
    AVAILABLE_OPTIONS = [:x, :y, :rotation, :size, :flip, :color, :hue, :saturation, :brightness]
    HSB_ORDER = {:hue => 0, :saturation => 1, :brightness => 2}
    
    def initialize()
      @rules = {}
      @finished = false
      @rewind_stack = []
      @matrix_stack = []
    end
    
    # Create an accessor for the current value of every option.
    AVAILABLE_OPTIONS.each do |option_name|
      define_method option_name do
        @values[option_name]
      end
    end
        
    def setup(some_hash)
      @starting_values = some_hash
      @starting_values[:stop_size] ||= STOP_SIZE
    end
    
    # A shortcut for defining methods on yourself.
    def create_method(name, &block)
      self.class.send(:define_method, name, &block)
    end
    
    # Here's the first serious method: A Rule has an 
    # identifying name, a probability, and is associated with 
    # a block of code. These code blocks are saved, and indexed 
    # by name in a hash, to be run later, when needed.
    # The method then dynamically defines a method of the same 
    # name here, in order to determine which rule to run.
    def rule(rule_name, prob=1, &proc)
      @rules[rule_name] ||= {:procs => [], :total => 0}
      total = @rules[rule_name][:total]
      @rules[rule_name][:procs] << [(total...(prob+total)), proc]
      @rules[rule_name][:total] += prob
      unless ContextFree.method_defined? rule_name
        self.class.class_eval do
          eval <<-METH
            def #{rule_name}(options)
              merge_options(@values, options)
              pick = determine_rule(#{rule_name.inspect})
              @finished = true if @values[:size] < STOP_SIZE
              unless @finished
                get_ready_to_draw
                pick[1].call(options)
              end
            end
          METH
        end
      end
    end
        
    # Rule choice is random, based on the assigned probabilities.
    def determine_rule(rule_name)
      rule = @rules[rule_name]
      chance = rand * rule[:total]
      pick = @rules[rule_name][:procs].select {|the_proc| the_proc[0].include?(chance) }
      return pick.flatten
    end
    
    # At each step of the way, any of the options may change, slightly.
    # Many of them have different strategies for being merged.
    def merge_options(old_ops, new_ops)
      return unless new_ops
      # Do size first
      old_ops[:size] *= new_ops[:size] if new_ops[:size]
      new_ops.each do |key, value|
        case key
        when :size
        when :x, :y
          old_ops[key] = value * old_ops[:size]
        when :rotation
          old_ops[key] = value * (Math::PI / 180.0)
        when :hue, :saturation, :brightness
          adjusted = old_ops[:color].dup
          adjusted[HSB_ORDER[key]] *= value
          old_ops[:color] = adjusted
        when :flip
          old_ops[key] = !old_ops[key]
        when :width, :height
          old_ops[key] *= value
        when :color
          old_ops[key] = value
        else # Used a key that we don't know about or trying to set
          merge_unknown_key(key, value, old_ops)
        end
      end
    end
    
    # Using an unknown key let's you set arbitrary values, 
    # to keep track of for your own ends.
    def merge_unknown_key(key, value, old_ops)
      key_s = key.to_s
      if key_s.match(/^set/)
        key_sym = key_s.sub('set_', '').to_sym
        if key_s.match(/(brightness|hue|saturation)/)
          adjusted = old_ops[:color].dup
          adjusted[HSB_ORDER[key_sym]] = value
          old_ops[:color] = adjusted
        else
          old_ops[key_sym] = value
        end
      end
    end
    
    # Doing a 'split' saves the context, and proceeds from there, 
    # allowing you to rewind to where you split from at any moment.
    def split(options=nil, &block)
      save_context
      merge_options(@values, options) if options
      yield
      restore_context
    end
    
    # TODO: Look into why the matrix stack isn't working quite right.
    
    def save_context
      @rewind_stack.push @values.dup
      # g = @app.g # The Graphics object
      # g.load_matrix
      # @matrix_stack << [g.m00, g.m01, g.m02,
      #                   g.m10, g.m11, g.m12]
      @app.push_matrix
    end
    
    def restore_context
      @values = @rewind_stack.pop
      # g = @app.g # The Graphics object
      # v = @matrix_stack.pop
      # g.reset_matrix
      # g.apply_matrix *v
      @app.pop_matrix
    end
    
    def rewind
      @finished = false
      restore_context
      save_context
    end
    
    # Render the is method that kicks it all off, initializing the options 
    # and calling the first rule.
    def render(rule_name)
      @values = {:x => 0, :y => 0, 
                 :rotation => 0, :flip => false, 
                 :size => 20, :width => 20, :height => 20,
                 :color => [0.5, 0.5, 0.5]}
      @values.merge!(@starting_values)
      @finished = false
      @app = $app
      @app.reset_matrix
      @app.no_stroke
      @app.color_mode(App::HSB, 1.0)
      @app.translate @values[:start_x], @values[:start_y]
      self.send(rule_name, {})
    end
    
    def get_ready_to_draw
      @app.translate(@values[:x], @values[:y])
      sign = (@values[:flip] ? -1 : 1)
      @app.rotate(sign * @values[:rotation])
    end
    
    def get_shape_values(some_options)
      old_ops = @values.dup
      merge_options(old_ops, some_options) if some_options
      @app.fill *old_ops[:color]
      return old_ops[:size], old_ops
    end
    
    # Square, circle, and oval are the primitive drawing
    # methods, but hopefully triangles will be added soon.
    def square(some_options=nil)
      size, options = *get_shape_values(some_options)
      @app.rect(-(size/2), -(size/2), size, size)
    end
    
    def circle(some_options=nil)
      size, options = *get_shape_values(some_options)
      @app.oval(-(size/2), -(size/2), size, size)
    end
    
    def oval(some_options=nil)
      rot = some_options[:rotation]
      @app.rotate(rot) if rot
      size, options = *get_shape_values(some_options)
      width = options[:width] || options[:size]
      height = options[:height] || options[:size]
      @app.oval(options[:x], options[:y], width, height)
      @app.rotate(-rot) if rot
    end
    alias_method :ellipse, :oval
    
  end
  
  # Processing::App's get a context_free method, as a hook for 
  # defining their rules.
  class App
    
    def context_free(&block)
      free = ContextFree.new
      free.instance_eval &block
      return free
    end
    
  end
  
end