class UsersController < ApplicationController
	before_filter :authenticate,	:only => [:index, :edit, :update, :destroy]
	before_filter :correct_user,	:only => [:edit, :update]
	before_filter :admin_user,		:only => :destroy
	
  def new
		@title = "Sign Up"
		@user = User.new
  end

	def show
		@user = User.find(params[:id])
		@title = @user.name
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Welcome to the Sample App!"
			sign_in @user
			redirect_to @user
		else
			@title = "Sign Up"
			render 'new'
		end
	end
	
	def edit
		@title = "Edit User"
	end
	
	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile Updated."
			redirect_to user_path(@user)
		else
			@title = "Edit User"
			render 'edit'
		end
	end
	
	def index
		@title = "All Users"
		@users = User.paginate(:page => params[:page])
	end
	
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_path
	end
	
	private
	
	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
	
	def authenticate
		deny_access unless signed_in?
	end
	
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end
	
end
