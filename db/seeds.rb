# create!は基本的にcreateメソッドと同じですが、ユーザーが無効な場合にfalseを返すのではなく例外を発生させる
User.create!(
              name: "admin user",
              email: "admin@railstutorial.org",
              password: "testtest",
              password_confirmation: "testtest",
              admin: true
            )

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

# TODO:モデルごとにシーダーを分割したい場合は？