module ActionFlow
  module WorkflowEngine
    module ClassMethods
      def create_workflow
        w = Workflow.new
        yield w if block_given?
        define_method(:workflow) { w }
        protected :workflow
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end
