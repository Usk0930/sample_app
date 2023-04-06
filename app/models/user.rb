class User < ApplicationRecord
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
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password
  # これつけると、saveメソッドが使えない？
  # 厳密には、saveメソッドで更新しようとした時、他のカラムは保存されているそのままの値が使われるが、
  # パスワードに関しては保存されているカラム名がpassword_digestであり、saveでpasswordのバリデーションに引っかかるため？
end
