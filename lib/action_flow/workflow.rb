module ActionFlow
  class Workflow
    def initialize(*steps)
      @steps = []
      steps.each { |s| step s }
    end
  
    def step(new_step, &action)
      if new_step.is_a?(Module) && new_step.instance_methods.include?("passes?") && 
          new_step.instance_methods.include?("execute")
        @steps << new_step
      else
        step = "#{new_step}_step".classify.constantize
        @steps << step
      end
    end
  
    def execute(controller)
      @steps.each_with_index do |s, i|
        controller.extend s
        controller.max_step_reached = i + 1
        unless controller.passes?
          controller.execute
          return true
        end
      end
      false
    end
  end
end
