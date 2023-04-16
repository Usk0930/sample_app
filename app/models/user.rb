class User < ApplicationRecord
  # 仮想の（DBにカラムが存在しない）属性を定義
  attr_accessor :remember_token
  # ↑パスワード用のremember_tokenはhas_secure_passwordが作ってくれている
  # TODO: この仕組みを復習する

  before_save { email.downcase! }

  # validatesメソッド
  # presenceは見ての通りハッシュのため本来は{}が必要だが、
  # メソッドの最後の引数としてハッシュを渡す場合、波カッコを付けなくても問題ない
  # (復習) :presence => true の省略形が  presence: true
  # 上の:presenceをシンボルという
  validates :name, presence: true, length: { maximum: 50 }

  # 大文字で始める場合は定数となる
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness:  { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true #allow_nilしているが、下記のhas_secure_passwordで検証してくれる

  has_secure_password
  # これつけると、saveメソッドが使えない？
  # 厳密には、saveメソッドで更新しようとした時、他のカラムは保存されているそのままの値が使われるが、
  # パスワードに関しては保存されているカラム名がpassword_digestであり、saveでpasswordのバリデーションに引っかかるため？

  # 渡された文字列のハッシュ値を返す
  # self.digestと書いてもUser.digestと書いても一緒
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token #ここはself.じゃだめっぽい・・？
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # クラスメソッドは下記の様にも書ける
  # class << self
  #   # 渡された文字列のハッシュ値を返す
  #   def digest(string)
  #     cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
  #                                                   BCrypt::Engine.cost
  #     BCrypt::Password.create(string, cost: cost)
  #   end

  #   # ランダムなトークンを返す
  #   def new_token
  #     SecureRandom.urlsafe_base64
  #   end
  # end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    # DBのremember_digestが削除済みの場合
    return false if remember_digest.nil?

    # この説明はちょっと複雑
    # https://railstutorial.jp/chapters/advanced_login?version=7.0#code-authenticated_p
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
