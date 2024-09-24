class BlocksController < ApplicationController
  before_action :require_login
  before_action :set_workspace
  before_action :set_page
  before_action :set_block, only: [:update, :destroy]

  def create
    @block = @page.blocks.new(block_params)

    respond_to do |format|
      if @block.save
        format.turbo_stream
        format.html { redirect_to @block, notice: 'Block was successfully created.' }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_block_form', partial: 'form', locals: { block: @block }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:position]
      @block.insert_at(params[:position].to_i)
      head :ok
    else 
      respond_to do |f|
        if @block.update(block_params)
          f.turbo_stream
        else 
          f.html { render :edit, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @block.destroy

    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to workspace_page_path(@workspace, @page) } 
    end
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def set_page
    @page = @workspace.pages.find(params[:page_id])
  end

  def set_block
    @block = @page.blocks.find(params[:id])
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to login_url
    end
  end

  def block_params
    params.require(:block).permit(:block_type, :content, :data, :position, :attachment)
  end
end
