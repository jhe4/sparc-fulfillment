class ServiceCalendarController < ApplicationController
  def change_page
    @page = params[:page]
    @arm = Arm.find params[:arm_id]
    @protocol = @arm.protocol
  end

  def check_visit
    visit = Visit.find(params[:visit_id])
    qty = params[:checked] == 'true' ? 1 : 0

    visit.update_attributes(research_billing_qty: qty, insurance_billing_qty: 0, effort_billing_qty: 0)
  end

  def change_visit_name
    visit_group = VisitGroup.find(params[:visit_group_id])
    name = params[:name]

    visit_group.update_attributes(name: name)
  end

  def check_row
    qty = params[:check] == 'true' ? 1 : 0
    Visit.where(line_item_id: params[:line_item_id]).update_all(research_billing_qty: qty, insurance_billing_qty: 0, effort_billing_qty: 0)
  end
end
