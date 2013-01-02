class LoginPanelController < ApplicationController
  layout false
  
  def show
    render '_show'
  end
end
