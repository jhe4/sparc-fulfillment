$("#modal_errors").html("<%= escape_javascript(render(:partial =>'shared/modal_errors', locals: {errors: @errors})) %>");
if $("#modal_errors > .alert.alert-danger > p").length == 0
  $("#flashes_container").html("<%= escape_javascript(render('flash')) %>");
  $('#task-list').bootstrapTable('refresh', {url: "/tasks.json", silent: "true"})
  $("#modal_place").modal 'hide'