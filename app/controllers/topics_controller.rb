class TopicsController < ApplicationController

  before_filter :set_tabs
  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }

  
  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private
    def set_tabs
      flash[:controller_tab_selected]=1
    end
end
