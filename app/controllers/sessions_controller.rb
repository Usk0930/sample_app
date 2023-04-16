class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
    # ↓と一緒
    # if user && user.authenticate(params[:session][:password])

      if @user.activated?
        forwarding_url = session[:forwarding_url]
        # セッション固定攻撃の対策でログイン直前にセッションをリセットする
        reset_session
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        log_in @user
        # redirect_to @user
        # 上は以下と同じらしい
        # user_url(user)

        redirect_to forwarding_url || @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    # 複数のブラウザを使用しており、片方でログアウト（セッション削除）し、もう片方で再度ログアウトしようとした場合に備えifをつける
    log_out  if logged_in?
    redirect_to root_url, status: :see_other
    # 303 See Otherステータスを指定することで、
    # DELETEリクエスト後のリダイレクトが正しく振る舞うようにする必要がある
  end
end
