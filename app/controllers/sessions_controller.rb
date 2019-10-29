class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      render json: 'Credentials were wrong.'
      render :new
    else
      #render json: "Welcome back #{user.username}"
      login!(user)
      redirect_to cats_url
    end
  end

  def destroy
    logout!
    redirect_to cats_url
  end
end