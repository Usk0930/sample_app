module SessionsHelper
  def log_in(user)
    # 下はメソッドらしい（ハッシュの様に扱える）
    session[:user_id] = user.id
    # セッションリプレイ攻撃から保護する
    # 詳しくは https://bit.ly/33UvK0w を参照
    session[:session_token] = user.session_token
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if (user_id = session[:user_id])
      # a ||= b は a = a || b の短縮系
      # findはデータが存在しない場合例外を返す、のでここでは例外じゃなくnilを返すfind_byを使用
      @current_user ||= User.find_by(id: user_id)
      # DBに何度も問い合わせしない様に↑インスタンス変数に格納
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  def logged_in?
    # railsでは全オブジェクトにnil?メソッドが定義されているため、nil判定はこれを使えばOK
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # アクセスしようとしたURLを保存する（未ログイン時に）
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
