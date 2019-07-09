require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    # 1. Visit the login path.
    get login_path
    # 2. Verify that the new sessions form renders properly.
    assert_template 'sessions/new'
    # 3. Post to the sessions path with an invalid params hash.
    post login_path, params: { session: { email: "", password: "" } }
    # 4. Verify that the new sessions form gets re-rendered and that a flash message appears.
    assert_template 'sessions/new'
    assert_not flash.empty?
    # 5. Visit another page (such as the Home page).
    get root_path
    # 6. Verify that the flash message doesn’t appear on the new page.
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    # 1. Visit the login path.
    get login_path
    # 2. Post valid information to the sessions path.
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    # 3. Verify that the login link disappears.
    assert_select "a[href=?]", login_path, count: 0
    # 4. Verify that a logout link appears
    assert_select "a[href=?]", logout_path
    # 5. Verify that a profile link appears.
    assert_select "a[href=?]", user_path(@user)
    # 6. Logout
    delete logout_path
    # 7. Verify logged out
    assert_not is_logged_in?
    assert_redirected_to root_path
    # 7.1 Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    # 8. Verify that the login link disappears.
    assert_select "a[href=?]", login_path
    # 9. Verify that logout and profile links appear
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

end
