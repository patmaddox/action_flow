require File.dirname(__FILE__) + '/spec_helper'

class PassStep
  def passes?(r)
    true
  end
  
  def execute_on(c)
  end
end

class FailStep
  def passes?(r)
    false
  end
  
  def execute_on(c)
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
    @pass_step = PassStep.new
    workflow.step @pass_step
  end
  
  specify "should check to see that the first step passes" do
    @pass_step.should_receive(:passes?).with(mock_resource).and_return true
    execute_workflow
  end

  specify "should not execute the step" do
    @pass_step.should_not_receive(:execute_on)
    execute_workflow
  end
  
  specify "should say it executed nothing" do
    execute_workflow.should_be false
  end
end

context "A workflow with 1 step that fails" do
  include WorkflowSpecHelpers
  
  setup do
    @fail_step = FailStep.new
    workflow.step @fail_step
  end

  specify "should execute the step on the controller" do
    @fail_step.should_receive(:execute_on).with(mock_controller)
    execute_workflow
  end
  
  specify "should say it executed something" do
    execute_workflow.should_be true
  end
end

context "A workflow with 1 step that passes and 1 step that fails" do
  include WorkflowSpecHelpers
  
  setup do
    @pass_step = PassStep.new
    workflow.step @pass_step
    @fail_step = FailStep.new
    workflow.step @fail_step
  end

  specify "should check to see if the first step passes" do
    @pass_step.should_receive(:passes?).and_return true
    execute_workflow
  end
  
  specify "should not execute the pass step" do
    @pass_step.should_not_receive(:execute_on)
    execute_workflow
  end
  
  specify "should check to see if the second step passes" do
    @fail_step.should_receive(:passes?).and_return false
    execute_workflow
  end
  
  specify "should execute the fail step" do
    @fail_step.should_receive(:execute_on)
    execute_workflow
  end
end

context "A workflow with two fail steps" do
  include WorkflowSpecHelpers
  
  setup do
    @fail1 = FailStep.new
    workflow.step @fail1
    @fail2 = FailStep.new
    workflow.step @fail2
  end

  specify "should check to see if the first step passes" do
    @fail1.should_receive(:passes?).and_return false
    execute_workflow
  end
  
  specify "should execute the first fail step" do
    @fail1.should_receive(:execute_on)
    execute_workflow
  end
  
  specify "should not check to see if the second step passes" do
    @fail2.should_not_receive(:passes?)
    execute_workflow
  end
  
  specify "should not execute the second fail step" do
    @fail2.should_not_receive(:execute_on)
    execute_workflow
  end
end

context "When #step is called with a symbol and block instead of a step object, a workflow" do
  include WorkflowSpecHelpers
  
  setup do
    @fake_step = mock("step")
    FakeStep = Class.new
    FakeStep.stub!(:new).and_return @fake_step
    @action = lambda {}
  end
  
  def add_step
    workflow.step :fake, &@action
  end
  
  specify "should infer the step class and create a new step" do
    FakeStep.should_receive(:new).with(&@action).and_return @fake_step
    add_step
  end
end

context "When initialized with an array of symbols, a workflow" do
  include WorkflowSpecHelpers
  setup do
    @mock_pass = mock("pass step")
    PassStep.stub!(:new).and_return @mock_pass
    @mock_fail = mock("fail step")
    FailStep.stub!(:new).and_return @mock_fail
  end

  def create_workflow
    @workflow = ActionFlow::Workflow.new :pass, :fail
  end
  
  specify "should create the first step" do
    PassStep.should_receive(:new).and_return @mock_pass
    create_workflow
  end
  
  specify "should create the second step" do
    FailStep.should_receive(:new).and_return @mock_fail
    create_workflow
  end
end
