class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "You are now logged in."
     flash[:notice] = "#{@template.link_to('To help prevent unauthorized use please change your password by clicking Account', account_path)}" if params[:user_session][:email] == params[:user_session][:password]

      redirect_to :action => "index", :controller => "manage"
    else
      render :action => :new
    end
  end
  
  
  
  def destroy
    current_user_session.destroy
    flash[:success] = "You have been logged out."
    redirect_back_or_default root_path
  end
end
