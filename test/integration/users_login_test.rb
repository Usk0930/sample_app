require "test_helper"

# 下記の様に複数クラスを書いたりする？

# setupのみのクラスは末尾にTestをつけない（Testをつけると単体で実行される）
class UsersLogin < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin

  test "login path" do
    get login_path
    assert_template 'sessions/new'
  end

  test "login with valid email/invalid password" do
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

class ValidLogin < UsersLogin

  def setup
    super
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
  end
end

class ValidLoginTest < ValidLogin

  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "redirect after login" do
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

class Logout < ValidLogin

  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout

  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "should still work after logout in second window" do
    delete logout_path
    assert_redirected_to root_url
  end
end

class RememberingTest < UsersLogin

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # assert_not cookies[:remember_token].blank?

    # 上の書き方はcookieの値の有無を確かめるだけ、integrationテストでは通常インスタンス変数にアクセスできないため、
    # 仮想で定義したremember_tokenにアクセスできずこの方法を取っていた
    # しかし、テスト内部でassignsメソッドを使うと下記の様にアクセスでき、cookieの値とユーザ変数のtokenを比較できる
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # remember_me: '1'の行は必要なの？
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end