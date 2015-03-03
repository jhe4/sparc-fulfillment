require 'rails_helper'

RSpec.describe AppointmentCalendarController do
  before :each do
    @user = create(:user)
    sign_in @user
    @protocol = create(:protocol_imported_from_sparc)
    @service = create(:service)
  end

  describe "PUT #complete_procedure" do

    it "sets a selected appointment to status compeleted" do
      procedure = create(:procedure, appointment: @protocol.participants.first.appointments.first)
      xhr :put, :complete_procedure, {
        procedure_id: procedure.id
      }
      procedure = Procedure.find(procedure.id)
      expect(procedure.status).to eq "complete"
      expect(procedure.notes.pluck(:comment)).to include "Set to completed"
    end
  end

  describe "GET #edit_follow_up" do
    it "should assign procedure and instantiate a note" do
      procedure = create(:procedure, appointment: @protocol.participants.first.appointments.first)
      xhr :get, :edit_follow_up, {
        procedure_id: procedure.id,
        format: :js
      }
      expect(assigns(:procedure)).to eq(procedure)
      expect(assigns(:note)).to be_a_new(Note)
    end
  end

  describe "PATCH #update_follow_up" do
    it "should update follow_up_date and add note" do
      procedure = create(:procedure, appointment: @protocol.participants.first.appointments.first)
      follow_up = (Date.today + 5.days).to_s
      patch :update_follow_up, {
        procedure_id: procedure.id,
        procedure: {follow_up_date: follow_up},
        note: {comment: "ta ta ta test"},
        format: :js
      }
      procedure.reload
      expect(procedure.follow_up_date).to eq(follow_up)
      expect(procedure.notes.pluck(:comment)).to include "Follow Up - #{follow_up} - ta ta ta test"
    end
  end
end
