require 'rails_helper'

feature 'Start Complete Buttons', js: true do

  before :each do
    given_i_am_viewing_an_appointment
  end

  scenario 'User visits appointment with no start date or completed_date' do
    then_i_should_see_the_start_button
    then_i_should_see_the_complete_button_disabled
  end

  scenario 'User visits appointment with start date but no completed date' do
    given_there_is_a_start_date
    when_i_load_the_page
    then_i_should_see_the_start_datepicker
    then_i_should_see_the_complete_button
  end

  scenario 'User visits appointment with start date and completed date' do
    given_there_is_a_start_date
    given_there_is_a_completed_date
    when_i_load_the_page
    then_i_should_see_the_start_datepicker
    then_i_should_see_the_completed_datepicker
  end

  scenario 'User clicks start button' do
    when_i_click_the_start_button
    then_i_should_see_the_start_datepicker
    then_i_should_see_the_complete_button
  end

  scenario 'User clicks complete button' do
    given_there_is_a_start_date
    when_i_load_the_page
    when_i_click_the_complete_button
    then_i_should_see_the_start_datepicker
    then_i_should_see_the_completed_datepicker
  end

  scenario 'User sets start date' do
    now = Time.current

    given_there_is_a_start_date
    when_i_load_the_page
    when_i_set_the_start_date(now)
    then_i_should_see_the_start_date_at(now)
  end

  scenario 'User sets completed date' do
    now = Time.current

    given_there_is_a_start_date
    given_there_is_a_completed_date
    when_i_load_the_page
    when_i_set_the_completed_date(now)
    then_i_should_see_the_completed_date_at(now)
  end

  scenario 'User sets start date to future then clicks complete button' do
    future = Time.current + 1.day

    given_there_is_a_start_date
    when_i_load_the_page
    when_i_set_the_start_date(future)
    when_i_click_the_complete_button
    then_i_should_see_the_completed_date_at(future)
  end

  def given_i_am_viewing_an_appointment
    @protocol    = create(:protocol_imported_from_sparc)
    @participant = @protocol.participants.first
    @appointment = @participant.appointments.first
    @visit_group = @appointment.visit_group

    visit protocol_participant_path @protocol, @participant
    bootstrap_select '#appointment_select', @visit_group.name
  end

  def given_there_is_a_start_date
    @appointment.start_date = Time.current
    @appointment.save
    @appointment.reload
  end

  def given_there_is_a_completed_date
    @appointment.completed_date = Time.current
    @appointment.save
    @appointment.reload
  end

  def when_i_load_the_page
    visit current_path
    bootstrap_select '#appointment_select', @visit_group.name
  end

  def when_i_click_the_start_button
    click_button 'Start Visit'
  end

  def when_i_click_the_complete_button
    click_button 'Complete Visit'
  end

  def when_i_set_the_start_date date
    find('input#start_date').click
    within '.bootstrap-datetimepicker-widget' do
      find("td.day", text: "#{date.day}").click
    end
    find(".control-label", text: "Start Date:").click
  end

  def when_i_set_the_completed_date date
    find('input#completed_date').click
    within '.bootstrap-datetimepicker-widget' do
      find("td.day", text: "#{date.day}").click
    end
    find(".control-label", text: "Completed Date:").click
  end

  def then_i_should_see_the_start_button
    expect(page).to have_css('button.btn-success.start_visit', visible: true)
  end

  def then_i_should_see_the_complete_button
    expect(page).to have_css('button.btn-danger.complete_visit', visible: true)
  end

  def then_i_should_see_the_complete_button_disabled
    expect(page).to have_css('button.btn-danger.complete_visit.disabled', visible: true)
  end

  def then_i_should_see_the_start_datepicker
    expect(page).to have_css('input#start_date', visible: true)
  end

  def then_i_should_see_the_completed_datepicker
    expect(page).to have_css('input#completed_date', visible: true)
  end

  def then_i_should_see_the_start_date_at date
    find('input#start_date').click
    expect(page).to have_css('td.day.active', text: "#{date.day}")
  end

  def then_i_should_see_the_completed_date_at date
    find('input#completed_date').click
    expect(page).to have_css('td.day.active', text: "#{date.day}")
  end
end