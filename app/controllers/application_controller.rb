class ApplicationController < ActionController::Base
  # 共通の親コントローラーでセッションヘルパーをincludeしてどこからでも呼び出せる様にする
  include SessionsHelper
end
