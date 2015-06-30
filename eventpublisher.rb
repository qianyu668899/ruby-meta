# EventPublisher v0.01
# 
# by Gijsbert dos Santos [g * j * d * dossantos (at) student * utwente * nl]
#
# Feel free to modify, experiment, copy and do whatever you want

module EventPublisher
  def add_listener(var, func)
    @callbacks ||= {}
    @callbacks[var] ||= []
    @callbacks[var] << func
    self
  end
  
  def remove_listener(var, func)
    return unless @callbacks
    return unless @callbacks[var]
    @callbacks[var].delete(func)
    self
  end
  
  def remove_all(var)
    return unless @callbacks
    @callbacks.delete(var)
    self
  end
  
  def has_listeners?(var)
    return false unless @callbacks
    return false unless @callbacks[var]
    return true
  end
  
  def is_listener?(var, func)
    return false unless has_listeners? var
    return (@callbacks[var].include? func)
  end
  
  def publish(var, new_value)
    return unless @callbacks
    return unless @callbacks[var]
    
    @callbacks[var].each do |func|
      if (func.arity == 0)
        func.call
      else
        func.call(new_value)
      end
    end
  end
  
end #EventPublisher

class Module
  def hook(*members)
    members.each do |member|
      class_eval do
        define_method(member) do
          instance_variable_get("@#{member}")
        end

        define_method("#{member}=") do |new_value|
          if (new_value != instance_variable_get("@#{member}"))
            puts "#{member.to_sym}, #{new_value}"
            publish(member.to_sym, new_value)
          end
          instance_variable_set("@#{member}", new_value)
        end              
      end
    end
  end
end

class Example
  include EventPublisher
  
  hook :test, :another_one
  
  def horrible_function(new_value)
    puts "horrible_function: #{new_value}"
  end
  
  def terrible_function
    puts "terrible_function"
  end
end

ex = Example.new
ex.test = 'test_one'

ex.add_listener(:test, ex.method(:horrible_function))
ex.add_listener(:test, ex.method(:terrible_function))
ex.add_listener(:test, lambda { |arg| puts "lambda: " + arg })
ex.add_listener(:test, lambda { puts "lambda2" })

ex.test = 'boo!'