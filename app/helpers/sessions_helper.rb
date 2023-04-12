module SessionsHelper
  def log_in(user)
    # 下はメソッドらしい（ハッシュの様に扱える）
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if session[:user_id]
      # a ||= b は a = a || b の短縮系
      # findはデータが存在しない場合例外を返す、のでここでは例外じゃなくnilを返すfind_byを使用
      @current_user ||= User.find_by(id: session[:user_id])
      # DBに何度も問い合わせしない様に↑インスタンス変数に格納
    end
  end

  def logged_in?
    # railsでは全オブジェクトにnil?メソッドが定義されているため、nil判定はこれを使えばOK
    !current_user.nil?
  end

  def log_out
    reset_session
    @current_user = nil
  end
end
