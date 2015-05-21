require 'rails_helper'

feature 'Line Items', js: true do

  let!(:service1)    { create(:service, name: 'Admiral Tuskface', one_time_fee: true) }
  let!(:service2)    { create(:service, name: 'Captain Cinnebon', one_time_fee: true) }
  let!(:pricing_map) { create(:pricing_map, service: service1, quantity_type: 'Case', effective_date: Time.current)}

  scenario 'User adds a new line item' do
    as_a_user_who_visits_study_level_activities_tab
    when_i_click_on_the_add_line_item_button
    then_i_fill_in_new_line_item_form
    i_should_see_the_line_item_on_the_page
    and_the_line_item_should_pull_pricing_map_data
  end

  scenario 'User edits an existing line item' do
    as_a_user_who_visits_study_level_activities_tab
    when_i_click_on_the_edit_line_item_button
    then_i_fill_in_the_edit_line_item_form
    i_should_see_the_changes_on_the_page
  end

  def as_a_user_who_visits_study_level_activities_tab
    protocol = create(:protocol_imported_from_sparc)

    visit protocol_path(protocol.sparc_id)
    click_link 'Study Level Activities'
  end

  def when_i_click_on_the_add_line_item_button
    first('.otf_service_new').click
  end

  def then_i_fill_in_new_line_item_form
    wait_for_ajax
    bootstrap_select '#line_item_service_id', 'Admiral Tuskface'
    fill_in 'Quantity Requested', with: 50
    page.execute_script %Q{ $('#date_started_field').trigger("focus") }
    page.execute_script %Q{ $("td.day:contains('15')").trigger("click") }
    click_button 'Save Line Item'
  end

  def i_should_see_the_line_item_on_the_page
    expect(page).to have_content('Admiral Tuskface')
  end

  def when_i_click_on_the_edit_line_item_button
    first('.otf_edit').click
  end

  def then_i_fill_in_the_edit_line_item_form
    wait_for_ajax
    bootstrap_select '#line_item_service_id', 'Captain Cinnebon'
    click_button 'Save Line Item'
  end

  def i_should_see_the_changes_on_the_page
    expect(page).to have_content('Captain Cinnebon')
  end

  def and_the_line_item_should_pull_pricing_map_data
    expect(page).to have_content('Case')
  end
end