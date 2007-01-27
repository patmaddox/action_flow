require File.dirname(__FILE__) + '/spec_helper'

class FakeStep
  include ActionFlow::WorkflowStep
end

context "Calling a WorkflowStep's execute_on method" do
  include WorkflowSpecHelpers
  
  setup do
    @action = lambda {}
    @step = FakeStep.new &@action
  end
  
  def execute_step
    @step.execute_on mock_controller
  end
  
  # These are combined because I can't stub a Proc right now
  specify "should bind the action to the controller and call the action" do
    @action.should_receive(:bind).with(mock_controller).and_return @action
    @action.should_receive(:call)
    execute_step
  end
end
