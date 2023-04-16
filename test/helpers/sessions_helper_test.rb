require "test_helper"

class SessionsHelperTest < ActionView::TestCase

  def setup
    # fixtureファイル名(:定義名)でfixtureを呼び出せる
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns user when session is nil" do
    # assert_equalの引数の順番は、＜期待する値＞, ＜実際の値＞
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end