require 'rails_helper'

feature 'Identity incompletes all Procedures', js: true do

  scenario 'User incompletes all procedures' do
    given_i_have_added_a_procedure_to_an_appointment(2)
    when_i_click_the_incomplete_all_button
    and_i_give_a_valid_reason
    then_all_the_procedure_incomplete_buttons_should_be_active
    and_all_procedures_should_be_incomplete
  end

  scenario 'User gives invalid reason' do
    given_i_have_added_a_procedure_to_an_appointment(2)
    when_i_click_the_incomplete_all_button
    and_i_give_an_invalid_reason
    then_i_should_see_an_error_message
  end

  def given_i_have_added_a_procedure_to_an_appointment(qty=1)
    protocol    = create_and_assign_protocol_to_me
    @participant = protocol.participants.first
    visit_group = @participant.appointments.first.visit_group
    service     = protocol.organization.inclusive_child_services(:per_participant).first

    visit participant_path @participant
    bootstrap_select '#appointment_select', visit_group.name
    bootstrap_select '#service_list', service.name
    fill_in 'service_quantity', with: qty
    find('button.add_service').click
    wait_for_ajax
    find('button.start_visit').click
    wait_for_ajax
  end

  def when_i_click_the_incomplete_all_button
    find('.incomplete_all_button').click
    wait_for_ajax
  end

  def and_i_give_a_valid_reason
    bootstrap_select '#reason.reason-select', "Assessment missed"
    find('button.btn.save').click
    wait_for_ajax
  end

  def then_all_the_procedure_incomplete_buttons_should_be_active
    expect(page).to have_css('label.status.incomplete.active', count: 2)
  end

  def and_all_procedures_should_be_incomplete
    expect(@participant.procedures.first.status).to eq("incomplete")
    expect(@participant.procedures.last.status).to eq("incomplete")
  end

  def and_i_give_an_invalid_reason
    find('button.btn.save').click
    wait_for_ajax
  end

  def then_i_should_see_an_error_message
    expect(page).to have_css('.alert.alert-danger')
    expect(page).to have_content("Reason can't be blank")
  end
end
