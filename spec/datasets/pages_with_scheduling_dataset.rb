class PagesWithSchedulingDataset < Dataset::Base
  uses :pages
  
  def load
    create_page "Expired", :appears_on => 2.days.ago.to_date, :expires_on => Date.yesterday
    create_page "Expired blank start", :expires_on => Date.yesterday
    create_page "Blank schedule"
    create_page "Visible blank start", :expires_on => Date.tomorrow
    create_page "Visible", :appears_on => Date.yesterday, :expires_on => Date.tomorrow
    create_page "Visible blank end", :appears_on => Date.yesterday
    create_page "Unappeared blank end", :appears_on => Date.tomorrow
    create_page "Unappeared", :appears_on => Date.tomorrow, :expires_on => 2.days.from_now.to_date
  end
end
