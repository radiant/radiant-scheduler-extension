require File.expand_path '../../spec_helper', __FILE__

describe "Scheduler::ControllerExtensions", :type => :controller do
  dataset :pages_with_scheduling
  controller_name :site
  
  it "should not render invisible pages in live mode" do
    get :show_page, :url => ['expired']
    response.should_not be_success
  end

  it "should render invisible pages in dev mode" do
    request.host = "dev.example.com"
    get :show_page, :url => ['expired']
    response.should be_success
  end
end
