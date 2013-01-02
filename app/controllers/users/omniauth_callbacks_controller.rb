# -*- coding: utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    # @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    oa_data=request.env["omniauth.auth"]
    @user=User.find_by_email(oa_data.info.email)
    if @user.nil?
      @user=User.create(:provider=>oa_data.provider,
                        :email=>oa_data.info.email,
                        :name=>generate_name(oa_data.info.nickname.empty? ? oa_data.info.first_name+' '+oa_data.info.last_name : oa_data.info.nickname),
                        :password=>Devise.friendly_token[0,20],
                        :ava_url=>oa_data.info.image                        
                        )
    end

    if @user.persisted?
      flash[:notice]='Добро пожаловать, '+@user.name+'!'
      sign_in @user
    else
      flash[:notice]='Ошибка авторизации.'
    end
    redirect_to '/'
    
  end

  
  #    render :inline=>@user.to_json
  #    if @user.persisted?
  #      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
  #      sign_in_and_redirect @user, :event => :authentication
  #    else
  #      session["devise.facebook_data"] = request.env["omniauth.auth"]
  #      redirect_to new_user_registration_url
  #    end


def vkontakte
  oa_data=request.env["omniauth.auth"]
  email="#{oa_data.uid}@vk.com"
  name=generate_name(oa_data.info.nickname.empty? ? oa_data.info.first_name+' '+oa_data.info.last_name : oa_data.info.nickname)
  
  user=User.find_by_email(email)
  unless user
    user=User.create(
                      :provider=>oa_data.provider,
                      :email=>email,
                      :name=>name,
                      :password=>Devise.friendly_token[0,20],
                      :ava_url=>oa_data.info.image
                 )
  end
  
  if user.persisted?
    flash[:notice]='Добро пожаловать, '+user.name+'!'
    sign_in user
  else
    flash[:notice]='Ошибка авторизации.'
  end
  
  redirect_to '/'
end

private

def generate_name(name,iter=0)
  return name if iter>99
  current_name=name+(iter==0 ? '' : iter.to_s)
  User.find_by_name(current_name) ? generate_name(name,iter+1) : current_name
end


end
