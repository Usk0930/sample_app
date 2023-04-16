require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  test "invalid signup information" do
    # postしたいだけのテストには不要だが、getでアクセスできるかも検証してる
    get signup_path
    # TODO:↓の書き方よくわかんない
    # なんでUser.countは文字列？
    assert_no_difference 'User.count' do
      # 改行の仕方独特じゃない？
      post users_path, params: { user: { name:  "",
        email: "user@invalid",
        password:              "foo",
        password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
  end

  # ユーザープロフィールに関する
  # ほぼ全て（例: ページにアクセスしたらなんらかの理由でエラーが発生しないかどうか）
  # をテストできている
  test "valid signup information with account activation" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup

  def setup
    super # 親クラスのsetupを実行
    post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
    @user = assigns(:user)
  end

  test "should not be activated" do
    assert_not @user.activated?
  end

  # TODO:accountとしないといけないところ、acountとしてしまった

  # test "should not be able to log in before account activation" do
  #   log_in_as(@user)
  #   assert_not is_logged_in?
  # end

  # test "should not be able to log in with invalid activation token" do
  #   get edit_acount_activation_path("invalid token", email: @user.email)
  #   assert_not is_logged_in?
  # end

  # test "should not be able to log in with invalid email" do
  #   get edit_acount_activation_path(@user.activation_token, email: 'wrong')
  #   assert_not is_logged_in?
  # end

  # test "should log in successfully with valid activation token and email" do
  #   get edit_acount_activation_path(@user.activation_token, email: @user.email)
  #   assert @user.reload.activated?
  #   follow_redirect!
  #   assert_template 'users/show'
  #   assert is_logged_in?
  # end
end