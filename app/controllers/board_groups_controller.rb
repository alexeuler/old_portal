class BoardGroupsController < ApplicationController

  before_filter :require_admin
  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }
  
  def new
    @board_group=BoardGroup.new
    render :action => "edit"
  end

  def create
    @board_group=BoardGroup.new(params[:board_group])
    if @board_group.save
      if request.xhr?
        render :text=>'redirect '+boards_path
      else
        redirect_to boards_path
      end
    else
      render :action => "edit"
    end
    
  end

  def edit
    @board_group=BoardGroup.find(params[:id])
    render :layout=>!request.xhr?
  end

  def update
    @board_group=BoardGroup.find(params[:id])

    if @board_group.update_attributes(params[:board_group])
      if request.xhr?
        render :text=>'redirect '+boards_path
      else
        redirect_to boards_path
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @board_group = BoardGroup.find(params[:id])
    @board_group.destroy
    if request.xhr?
      render :text=>'redirect '+boards_path
    else
      redirect_to boards_path
    end
  end

end
