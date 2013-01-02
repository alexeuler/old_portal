class HomeController < ApplicationController
  before_filter:set_tabs
  
  def index
    render :layout=>!request.xhr?
  end

  private

  def set_tabs
    flash[:controller_tab_selected]=0
  end
end
