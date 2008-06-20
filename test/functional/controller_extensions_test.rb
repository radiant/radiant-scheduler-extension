require File.dirname(__FILE__) + '/../test_helper'
class SiteController; def rescue_action(e); raise e; end end

class ControllerExtensionsTest < Test::Unit::TestCase
  fixtures :pages
  
  def setup
    @controller = SiteController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_should_not_render_unpublished_children
    get :show_page, :url => '/'
    assert_response :success
    [:unexpired, :all_blank, :unexpired_with_blank_start].each do |page|
      assert_tag :tag => "li", :content => page.to_s.humanize
    end
    [:unpublished, :unpublished_with_blank_end, :expired, :expired_with_blank_start].each do |page|
      assert_no_tag :tag => "li", :content => page.to_s.humanize
    end
  end
end
