# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "login_dialog"
    else
      "application"
    end
  end

  def admin?
    false
    if user_signed_in? then
      if current_user.admin? then
        true
      end
    end
  end

  def require_admin
    render :inline=>'Доступно только администраторам' unless admin? 
  end

  private

 
end
