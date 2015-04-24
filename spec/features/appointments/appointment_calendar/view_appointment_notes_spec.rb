require 'rails_helper'

feature 'View appointment notes', js: true do
  before :each do
    protocol    = create(:protocol_imported_from_sparc)
    @participant = protocol.participants.first
    @visit_group = @participant.appointments.first.visit_group
    @user = create(:user)
  end

  scenario 'User views Notes list when no Notes are present' do
    given_i_am_viewing_a_appointment
    when_i_view_the_notes_list
    then_i_should_be_notified_that_there_are_no_notes
  end
  
  scenario 'User views Notes list when Notes are present' do
    given_i_am_viewing_a_appointment
    when_i_create_a_note
    when_i_view_the_notes_list
    then_i_should_be_notified_that_there_are_notes
  end

  def given_i_am_viewing_a_appointment
    visit participant_path @participant
    bootstrap_select '#appointment_select', @visit_group.name
  end

  def when_i_view_the_notes_list
    find('h3.appointment_header button.notes.list').click
  end
  
  def when_i_create_a_note
    @participant.appointments.first.notes.create :comment => "A note", :user => @user
  end

  def then_i_should_be_notified_that_there_are_no_notes
    expect(page).to have_css('.modal-body', text: 'This appointment has no notes.')
  end
  
  def then_i_should_be_notified_that_there_are_notes
    expect(page).to have_css('.modal-body', text: 'A note')
  end
end
