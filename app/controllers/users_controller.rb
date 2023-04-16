class UsersController < ApplicationController
  # onlyのアクションに対して事前に第一引数のメソッドが実行される
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

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
    # @user = User.new(user_params)

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  # こっから下に書いた記述はprivateになる
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # ログイン済みユーザか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end

    # 正しいユーザか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end

  # こっから下に書いた記述はprotectedになる
  protected
end
