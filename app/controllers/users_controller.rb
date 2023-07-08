class UsersController < ApplicationController
  before_action :authorize, only: [:show]

  def create
    user = User.new(user_params)
    if params[:password] == params[:password_confirmation] && user.save
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: session[:user_id])
    render json: user, status: :ok
  end

  private

  def authorize
     render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id 
  end

  def user_params
    params.permit(:username, :password)
  end
end
