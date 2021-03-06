require 'spec_helper'

describe User do
	
	before(:each) do
		@attr = { 
			:name => "Example User", 
			:email => "user@example.com",
			:password => "password",
			:password_confirmation => "password"
			}
	end
	
	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end
	it "should require an email address" do
		no_email_user = User.new(@attr.merge(:email => ""))
		no_email_user.should_not be_valid
	end
	it "should reject names that are too long" do
		long_name = "a"*51
		long_name_user = User.new(@attr.merge(:name => long_name))
		long_name_user.should_not be_valid
	end
	it "should accept valid email addresses" do
		addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		addresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should be_valid
		end
	end
	it "should reject invalid email addresses" do
		addresses = %w[user@foo,com user_at_foo.com first.last@example.]
		addresses.each do |address|
			invalid_email_user = User.new(@attr.merge(:email => address))
			invalid_email_user.should_not be_valid
		end
	end
	it "should reject duplicate email addresses" do
		User.create!(@attr)
		duplicate_email_user = User.new(@attr)
		duplicate_email_user.should_not be_valid
	end
	it "should reject email addresses identical up to case" do
		User.create!(@attr.merge(:email => @attr[:email].upcase))
		duplicate_email_user = User.new(@attr)
		duplicate_email_user.should_not be_valid
	end

	describe "password validations" do
		
		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).
				should_not be_valid
		end
		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "different")).
				should_not be_valid
		end
		it "should reject short passwords" do
			User.new(@attr.merge(:password => "short", :password_confirmation => "short")).
				should_not be_valid
		end
		it "should reject long passwords" do
			pw = "a"*41
			User.new(@attr.merge(:password => pw, :password_confirmation => pw)).
				should_not be_valid
		end
		
	end

	describe "password encryption" do
		
		before (:each) do
			@user = User.create!(@attr)
		end
		
		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end
		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end
		
		describe "has_password? method" do
			
			it "should be true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end
			it "should be false if the passwords don't match" do
				@user.has_password?("diff pass").should be_false
			end
			
		end
		
		describe "authenticate method" do
			
			it "should return nil on wrong password" do
				wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
				wrong_password_user.should be_nil
			end
			it "should return nil for an email address with no user" do
				no_such_user = User.authenticate("Nobody@here.com", @attr[:password])
				no_such_user.should be_nil
			end
			it "should return the user on email/password match" do
				correct_user = User.authenticate(@attr[:email],@attr[:password])
				correct_user.should == @user
			end
#			it "should return the user on miscased email, matching password"
			
		end
	end
	
	describe "admin attribute" do
		
		before(:each) do
			@user = User.create!(@attr)
		end
		
		it "should respond to admin" do
			@user.should respond_to(:admin)
		end
		
		it "should not be an admin by default" do
			@user.should_not be_admin
		end
		
		it "should be convertible to an admin" do
			@user.toggle!(:admin)
			@user.should be_admin
		end
		
	end
	
end
