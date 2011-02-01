class SessionsController < ApplicationController
	
  def new
		@title = "Sign In"
  end
	
	def create
		user = User.authenticate( params[:session][:email],
															params[:session][:password])
		if user.nil?
			# Create an error message and re-render
		else
			# Sign the user in and redirect to the user's show page
		end
	end
	
	def destroy
	end

end
