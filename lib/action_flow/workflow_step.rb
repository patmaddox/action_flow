module ActionFlow::WorkflowStep
  def initialize(&action)
    @action = action
  end
  
  def execute_on(controller)
    action.bind(controller).call
  end
  
  protected
  attr_reader :action
end