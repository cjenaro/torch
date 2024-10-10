class BlocksController < ApplicationController
  before_action :require_login
  before_action :set_workspace
  before_action :set_page
  before_action :set_block, only: [ :update, :destroy ]

  def create
    @block = @page.blocks.new(block_params)
    @insert_after = params[:insert_after]

    respond_to do |format|
      if @block.save
        format.turbo_stream
        format.html { redirect_to workspace_page_path(@workspace, @page), notice: "Block was successfully created." }
      else
        format.turbo_stream
        format.html { redirect_to workspace_page_path(@workspace, @page), alert: "Couldn't create block." }
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
          f.json { render json: { success: true } }
          f.html { redirect_to workspace_page_path(@workspace, @page), notice: "Block updated." }
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

  def batch_update_positions
    blocks_data = params[:blocks]

    unless blocks_data.is_a?(Array)
      render json: { error: "Invalid data format" }, status: :unprocessable_entity
      return
    end

    Block.transaction do
      blocks_data.each do |block_data|
        block = @page.blocks.find_by(id: block_data[:id])

        if block.nil?
          render json: { error: "Block with  id #{block_data[:id]} not found" }, status: :not_found
          raise ActiveRecord::Rollback
        end

        unless block.update(position: block_data[:position])
          render json: { error: block.errors.full_messages }, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
    end

    head :ok
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
