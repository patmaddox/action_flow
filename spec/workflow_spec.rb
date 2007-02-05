require File.dirname(__FILE__) + '/spec_helper'

module PassStep
  def passes?
    true
  end
  
  def execute
  end
end

module FailStep
  def passes?
    false
  end
  
  def execute
  end
end

context "A workflow with 0 steps" do
  include WorkflowSpecHelpers

  specify "should say it executed nothing" do
    execute_workflow.should_be false
  end
end

context "A workflow with 1 step that passes" do
  include WorkflowSpecHelpers
  
  setup do
    @pass_step = PassStep
    workflow.step @pass_step
  end
  
  # Somehow I need to show that it extended it
  #specify "should extend the controller with the step" do
  #  mock_controller.should_receive(:extend).with(@pass_step)
  #  execute_workflow
  #end

  specify "should not execute the step" do
    mock_controller.should_not_receive(:execute)
    execute_workflow
  end
  
  specify "should say it executed nothing" do
    execute_workflow.should_be false
  end
end

context "A workflow with 1 step that fails" do
  include WorkflowSpecHelpers
  
  setup do
    @fail_step = FailStep
    workflow.step @fail_step
  end

  specify "should execute the step on the controller" do
    mock_controller.should_receive(:execute)
    execute_workflow
  end
  
  specify "should say it executed something" do
    execute_workflow.should_be true
  end
end

context "A workflow with 1 step that passes and 1 step that fails" do
  include WorkflowSpecHelpers
  
  setup do
    @pass_step = PassStep
    workflow.step @pass_step
    @fail_step = FailStep
    workflow.step @fail_step
  end
  
  specify "should check to see if the first step passes" do
    mock_controller.should_receive(:passes?).twice.and_return true, false
    execute_workflow
  end
  
  # Somehow I have to specify that it's the fail step that executes
  specify "should execute the step" do
    mock_controller.should_receive(:execute)
    execute_workflow
  end
end

context "A workflow with two fail steps" do
  include WorkflowSpecHelpers
  
  setup do
    @fail1 = FailStep
    workflow.step @fail1
    @fail2 = FailStep
    workflow.step @fail2
  end

  specify "should check to see if the first step passes but not the second step" do
    mock_controller.should_receive(:passes?).once.and_return false
    execute_workflow
  end
end

context "When initialized with an array of symbols, a workflow" do
  include WorkflowSpecHelpers

  def create_workflow
    @workflow = ActionFlow::Workflow.new :pass, :fail
    @workflow.execute mock_controller
  end
  
  specify "should check to see if the first step passes" do
    mock_controller.should_receive(:passes?).twice.and_return true, false
    create_workflow
  end
  
  # Somehow I have to specify that it's the fail step that executes
  specify "should execute the step" do
    mock_controller.should_receive(:execute)
    create_workflow
  end
end
