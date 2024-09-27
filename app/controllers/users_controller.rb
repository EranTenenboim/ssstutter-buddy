# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit change_password update destroy]

  # GET /users/1
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # GET /users/1/change_password
  def change_password; end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render :select_role
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated!', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.', status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user).permit(:first_name, :last_name, :email, :password, :password_digest, :password_confirmation)
  end
end
