require File.dirname(__FILE__) + '/spec_helper'
include ActionFlow

context "When told to create a workflow, the WorkflowEngine" do
  setup do
    @klass = Class.new { include ActionFlow::WorkflowEngine }
    @mock_flow = mock("flow")
    Workflow.stub!(:new).and_return @mock_flow
  end

  def do_create
    @klass.send(:create_workflow) { }
  end
  
  specify "should create a new workflow" do
    Workflow.should_receive(:new).and_return @mock_flow
    do_create
  end
  
  # TODO: How do I spec that it yields the workflow?
  
  # TODO: How do I spec the block that's passed in?
  specify "should define a workflow instance method to return the workflow" do
    @klass.should_receive(:define_method).with(:workflow)
    @klass.should_receive(:protected).with(:workflow)
    do_create
  end
end
