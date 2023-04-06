require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
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
  test "valid signup information" do
    assert_difference 'User.count' do
      post users_path, params: { user: { name:  "Example User",
        email: "user@example.com",
        password:              "password",
        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
  end
end
