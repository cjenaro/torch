class WorkspacesController < ApplicationController
  before_action :require_login
  before_action :set_workspace, only: [:show, :edit, :update, :destroy, :manage_members]
  before_action :authorize_workspace, except: [:index, :new, :create] 

  def index
    @workspaces = current_user.workspaces
  end

  def show
  end

  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)

    if @workspace.save
      Membership.create(user: current_user, workspace: @workspace, role: :owner)
      flash[:notice] = "Workspace created"
      redirect_to @workspace
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @workspace.update(workspace_params)
      flash[:notice] = "Workspace updated"
      redirect_to @workspace
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workspace.destroy
    flash[:notice] = "Workspace deleted"
    redirect_to workspaces_path
  end

  def manage_members
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:id])
  end

  def authorize_workspace
    authorize @workspace
  end

  def workspace_params
    params.require(:workspace).permit(:name, :description)
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to login_url
    end
  end
end
