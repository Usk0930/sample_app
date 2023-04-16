class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    # rails sを実行したターミナルでdebuggerが呼び出された瞬間の状態（変数など）を確認できる
    # TODO:docker等でサーバー起動している場合はどこで確認できる？
    # debugger
  end

  def new
    @user = User.new
  end

  def create
  # 下記の書き方だとNG、params丸ごと渡すのは悪意あるパラメータが紛れ込んだ場合危険なため
  # @user = User.find(params[:id])

  # user_paramsはストロングパラメータといい、コントローラ内で必須パラメータと許可済みパラメータを指定する
  @user = User.new(user_params)

    @user = User.new(user_params)
    if @user.save
      reset_session
      remember @user
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # 下記と同じ
      # redirect_to user_url(@user)
      # その理由は、redirect_to @userというコードを書くと、実際にはuser_url(@user)に
      # リダイレクトしたいということをRailsが自動的に推測してくれるから
      # そしてリンク先のパスとしてモデルオブジェクトが渡された場合、
      # Railsはオブジェクトを一意に表す値、つまり、idを取得しようします。
      # だから最終的には、redirect_to @userは、redirect_to user_url(@user.id)と等価となります。
    else
      render 'new', status: :unprocessable_entity #HTTPステータスコード422 Unprocessable Entityに対応するもの
    end
  end

  # こっから下に書いた記述はprivateになる
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

  # こっから下に書いた記述はprotectedになる
  protected
end
