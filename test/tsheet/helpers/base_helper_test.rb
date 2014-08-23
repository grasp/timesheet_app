require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "TimesheetApp::Tsheet::BaseHelper" do
  setup do
    helpers = Class.new
    helpers.extend TimesheetApp::Tsheet::BaseHelper
    [helpers.foo]
  end

  asserts("#foo"){ topic.first }.nil
end
