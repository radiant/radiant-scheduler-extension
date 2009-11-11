require File.dirname(__FILE__) + '/../spec_helper'
require 'ruby-debug'
describe "Scheduler::PageExtensions" do
  dataset :pages_with_scheduling

  describe "finding pages" do
    it "should wrap the find_by_url method" do
      Page.should respond_to(:find_by_url_with_scheduling)
    end

    it "should find visible pages in both modes" do
      [true, false].each do |live|
        [:blank_schedule, :visible, :visible_blank_start, :visible_blank_end].each do |page|
          Page.find_by_url(pages(page).url, live).should == pages(page)
        end
      end
    end

    it "should not find pages scheduled outside the window when live" do
      [:expired, :expired_blank_start, :unappeared, :unappeared_blank_end].each do |page|
        Page.find_by_url(pages(page).url).should_not == pages(page)
      end
    end

    it "should find pages scheduled outside the window when dev" do
      [:expired, :expired_blank_start, :unappeared, :unappeared_blank_end].each do |page|
        Page.find_by_url(pages(page).url, false).should == pages(page)
      end
    end
  end

  describe "scheduling interrogators" do
    before :each do
      @page = Page.new
    end

    describe "appeared?" do
      it "should be true when the page has no limits" do
        @page.should be_appeared
      end

      it "should be true when the page has no start date" do
        @page.appears_on = nil
        @page.expires_on = Date.tomorrow
        @page.should be_appeared
      end

      it "should be true when the start date is in the past" do
        @page.appears_on = Date.yesterday
        @page.expires_on = Date.tomorrow
        @page.should be_appeared
      end

      it "should be false when the start date is in the future" do
        @page.appears_on = Date.tomorrow
        @page.should_not be_appeared
      end
    end

    describe "expired?" do
      it "should be false when the page has no limits" do
        @page.should_not be_expired
      end

      it "should be false when the page has no end date" do
        @page.appears_on = Date.yesterday
        @page.expires_on = nil
        @page.should_not be_expired
      end

      it "should be false when the end date is in the future" do
        @page.expires_on = Date.tomorrow
        @page.should_not be_expired
      end

      it "should be true when the end date is in the past" do
        @page.expires_on = Date.yesterday
        @page.should be_expired
      end
    end

    describe "visible?" do
      before :each do
        @page.stub!(:published?).and_return(true)
      end

      it "should be true when the page is appeared and not expired" do
        @page.stub!(:appeared?).and_return(true)
        @page.stub!(:expired?).and_return(false)
        @page.should be_visible
      end
      it "should be false when the page has not appeared" do
        @page.stub!(:appeared?).and_return(false)
        @page.stub!(:expired?).and_return(false)
        @page.should_not be_visible
      end
      it "should be false when the page has expired" do
        @page.stub!(:appeared?).and_return(true)
        @page.stub!(:expired?).and_return(true)
        @page.should_not be_visible
      end
      it "should be false when the page is unpublished" do
        @page.stub!(:published?).and_return(false)
        @page.should_not be_visible
      end
    end
  end

  describe "<r:children>" do
    before :each do
      raise "dev site configured" if Radiant::Config['dev.site']
    end

    it "should render only visible children in live mode" do
      pages(:home).should render("<r:children:each><r:title /> </r:children:each>").matching(%r{^((?!expired)(?!unappeared).)*$}i)
    end

    it "should render all children in dev mode" do
      pages(:home).should render("<r:children:each><r:title /> </r:children:each>").matching(%r{expired}i).on("dev.example.com")
      pages(:home).should render("<r:children:each><r:title /> </r:children:each>").matching(%r{unappeared}i).on("dev.example.com")
    end
  end
end
