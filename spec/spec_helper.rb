plugin_spec_dir = File.dirname(__FILE__)
require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

module WorkflowSpecHelpers
  def mock_resource
    @mock_resource ||= mock("resource")
  end

  def mock_controller
    @mock_controller ||= mock("controller")
  end

  def workflow
    @workflow ||= ActionFlow::Workflow.new
  end

  def execute_workflow
    workflow.execute mock_resource, mock_controller
  end
end
