require File.expand_path '../../spec_helper', __FILE__

describe "Scheduler::PageExtensions" do
  dataset :pages_with_scheduling

  describe "finding pages" do
    it "should wrap the find_by_path method" do
      Page.should respond_to(:find_by_path_with_scheduling)
    end

    it "should find visible pages in both modes" do
      [true, false].each do |live|
        [:blank_schedule, :visible, :visible_blank_start, :visible_blank_end].each do |page|
          Page.find_by_path(pages(page).url, live).should == pages(page)
        end
      end
    end

    it "should not find pages scheduled outside the window when live" do
      [:expired, :expired_blank_start, :unappeared, :unappeared_blank_end].each do |page|
        Page.find_by_path(pages(page).url).should_not == pages(page)
      end
    end

    it "should find pages scheduled outside the window when dev" do
      [:expired, :expired_blank_start, :unappeared, :unappeared_blank_end].each do |page|
        Page.find_by_path(pages(page).url, false).should == pages(page)
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
