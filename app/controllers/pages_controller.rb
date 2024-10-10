class PagesController < ApplicationController
  before_action :require_auth
  before_action :set_workspace
  before_action :set_page, only: [ :show, :edit, :update, :destroy, :duplicate ]
  before_action :authorize_page, except: [ :new, :create, :update ]

  def new
    @page = @workspace.pages.new(parent_id: params[:parent_id])
    @templates = @workspace.pages.where(is_template: true)
  end

  def create
    @page = @workspace.pages.new(page_params)
    @page.creator = current_user

    if params[:template_id].present?
      template = @workspace.pages.find(params[:template_id])
      @page.blocks = template.blocks.map do |block|
        block.dup
      end
    end

    if @page.save
      @workspace.activities.create(user: current_user, action: "created", trackable: @page)
      flash[:notice] = "Page created"
      redirect_to workspace_page_path(@workspace, @page)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def duplicate
    # create new page from exisitng one
  end

  def edit
  end

  def update
    if @page.update(page_params)
      respond_to do |format|
        format.turbo_stream
        format.json { render json: { success: true } }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy
    flash[:notice] = "Page deleted"
    redirect_to workspace_path(@workspace)
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def set_page
    @page = @workspace.pages.find(params[:id])
  end

  def authorize_page
    authorize @page
  end

  def page_params
    params.require(:page).permit(:title, :parent_id)
  end

  def require_auth
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to login_url
    end
  end
end
