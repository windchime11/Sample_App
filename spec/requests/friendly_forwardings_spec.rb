require 'spec_helper'

describe "FriendlyForwardings" do

  #<code by me below
    it "should forward to the requested page after signing-in" do
      user = Factory(:user)
      visit edit_user_path(user)
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      click_button
      #redirect_to(edit_user_path(user)) does not get the test passed
      #even after the page IS redirected.
      response.should render_template('users/edit')
    end
  #code by me>

end
