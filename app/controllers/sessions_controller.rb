class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
    # ↓と一緒
    # if user && user.authenticate(params[:session][:password])
      # セッション固定攻撃の対策でログイン直前にセッションをリセットする
      reset_session
      log_in user
      redirect_to user
      # 上は以下と同じらしい
      # user_url(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
    # 303 See Otherステータスを指定することで、
    # DELETEリクエスト後のリダイレクトが正しく振る舞うようにする必要がある
  end
end