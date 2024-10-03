class DatabaseEntriesController < ApplicationController
  before_action :require_login
  before_action :set_workspace
  before_action :set_page
  before_action :set_block
  before_action :set_database_entry, only: [:edit, :update, :destroy]

  def new
    @database_entry = @block.database_entries.new
  end

  def create
    @database_entry = @block.database_entries.new(database_entry_params)
    if @database_entry.save
      redirect_to workspace_page_path(@workspace, @page), notice: 'Entry was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @database_entry.update(database_entry_params)
      redirect_to workspace_page_path(@workspace, @page), notice: 'Entry was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @database_entry.destroy
    redirect_to workspace_page_path(@workspace, @page), notice: 'Entry was successfully deleted.'
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def set_page
    @page = @workspace.pages.find(params[:page_id])
  end

  def set_block
    @block = @page.blocks.find(params[:block_id])
  end

  def set_database_entry
    @database_entry = @block.database_entries.find(params[:id])
  end

  def database_entry_params
    params.require(:database_entry).permit(properties: {})
  end
end
