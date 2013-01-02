# -*- coding: utf-8 -*-
class BoardsController < ApplicationController

  before_filter :set_tabs
  before_filter :require_admin, :except=>[:index]
  
  
  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }
 
  def index
    @board_groups=BoardGroup.includes(:boards).order("item_order").all
  end

  def new
    @board=Board.new
    @board.board_group_id=params[:board_group_id]
    @board_groups=BoardGroup.all
    @init_group=@board_groups.find{|bg| bg.id==@board.board_group_id}.name
    render :action => "edit"
  end

  def create
    #convert text from field to id
    params[:board][:board_group_id]=BoardGroup.find_or_create_by_name(params[:board][:board_group_id]).id
    @board=Board.new(params[:board])
    @board.posts_number=0
    if @board.save
      if request.xhr?
        render :text=>'redirect '+boards_path
      else
        redirect_to :action => "index"
      end
    else
      render :action => "edit"
    end
  end

  def edit
    @board=Board.find(params[:id])
    @board_groups=BoardGroup.all
    @init_group=@board_groups.find{|bg| bg.id==@board.board_group_id}.name
  end

  def update
    @board=Board.find(params[:id])
    @board.posts_number=0
    #convert text from field to id
    params[:board][:board_group_id]=BoardGroup.find_or_create_by_name(params[:board][:board_group_id]).id
    if @board.update_attributes(params[:board])
      if request.xhr?
        render :text=>'redirect '+boards_path
      else
        redirect_to :action => "index"
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    if request.xhr?
      render :text=>'redirect '+boards_path
    else
      redirect_to :action => "index"
    end
  end

  private
 
  def set_tabs
    flash[:controller_tab_selected]=1
  end

  def create_or_find_board_group(name)
    bg=BoardGroup.find_by_name(name)
  end

end
