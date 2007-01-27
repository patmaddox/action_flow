module ActionFlow
  class Workflow
    def initialize(*steps)
      @steps = []
      steps.each { |s| step s }
    end
  
    def step(new_step, &action)
      if new_step.respond_to?(:passes?) && new_step.respond_to?(:execute_on)
        @steps << new_step
      else
        step = "#{new_step}_step".classify.constantize.new &action
        @steps << step
      end
    end
  
    def execute(resource, controller)
      @steps.each do |s|
        unless s.passes?(resource)
          s.execute_on controller
          return true
        end
      end
      false
    end
  end
end
