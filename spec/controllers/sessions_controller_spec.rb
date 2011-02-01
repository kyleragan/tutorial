require 'spec_helper'

describe SessionsController do
	render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
		
		it "should have the right title" do
			get :new
			response.should have_selector("title", :content => "Sign In")
		end
		
  end
	
	describe "POST 'create'" do
		
		describe "invalid signin" do
			
			it "should re-render the new page"
			it "should have the right title"
			it "should have a flash.now message"
			
		end
		
		describe "with valid email and password" do
			
			it "should sign the user in"
			it "should redirect to the user show page"
			
		end
		
	end

end
