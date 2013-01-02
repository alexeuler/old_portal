# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :authentication_keys => [:login] #:validatable,

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :name, :email, :password, :provider, :ava_url, :uid
  # attr_accessible :title, :body

  validates_format_of :email, :with=>/\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i, :message=>"^Неверный формат Email"
  validates_uniqueness_of :email, :message=>"^Пользователь с таким Email уже существует"
  validates_presence_of :name, :message=>"^Заполните поле Имя"
  validates_uniqueness_of :name, :message=>"^Пользователь с таким именем уже существует"
  validates_presence_of :password, :message=>"^Заполните поле Пароль"
  
  
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def admin?
    role=='admin'
  end
  
  
end
