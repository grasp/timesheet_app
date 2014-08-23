require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "TimesheetApp::App::BaseHelper" do
  setup do
    helpers = Class.new
    helpers.extend TimesheetApp::App::BaseHelper
    [helpers.foo]
  end

  asserts("#foo"){ topic.first }.nil
end
