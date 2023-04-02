class User
  attr_accesor :name, :email

  def initialize(attributes = {})
    # @からはじまるのはインスタンス変数（プロパティ）
    @name = attributes[:name]
    @email = attributes[:email]
  end

  def formatted_email
    "#{@name}"
  end
end