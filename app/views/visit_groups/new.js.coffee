$("#modal_area").html("<%= escape_javascript(render(:partial =>'protocols/study_schedule/add_visit_form', locals: {visit_group: @visit_group, arm: @arm, current_page: @current_page, calendar_tab: @calendar_tab})) %>");
$("#modal_place").modal 'show'
$(".selectpicker").selectpicker()