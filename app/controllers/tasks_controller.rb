class TasksController < ApplicationController

  before_action :find_task, only: [:show, :update, :task_reschedule]

  respond_to :json, :html

  def index
    respond_to do |format|
      format.html { render }
      format.json do
        show_complete = to_boolean(params[:complete])
        @tasks = Task.mine(current_user, show_complete)

        render
      end
    end
  end

  def show
    @partial = ["show", @task.assignable_type.downcase, "task"].join("_")
  end

  def new
    @task = Task.new()
  end

  def create
    task_parameters = task_params.to_h.except("notes")
    if task_params[:notes]
      task_parameters[:body] = task_params[:notes][:comment]
    end
    puts task_parameters
    @task = Task.new(task_parameters.merge!({ user: current_user}))
    if @task.valid?
      @task.save
      if task_params[:notes]
        create_note
      end
      flash[:success] = t(:flash_messages)[:task][:created]
    else
      @errors = @task.errors
    end
  end

  def update
    if @task.update_attributes(task_params)
      flash[:success] = t(:flash_messages)[:task][:updated]
    end
  end

  def task_reschedule
  end

  private

  def create_note
    unless task_params[:notes][:comment].empty?
      notes_params = task_params[:notes]
      Note.create(notes_params)
    end
  end


  def to_boolean string
    if string == 'true'
      return true
    elsif string == 'false'
      return false
    end
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.
      require(:task).
      permit(:complete, :body, :due_at, :assignee_id, :assignable_type, :assignable_id, notes: [:kind, :comment, :notable_type, :notable_id])
  end
end
