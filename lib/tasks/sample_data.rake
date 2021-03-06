#
# データベースに、サンプルのユーザーを追加する
#
# $ rake db:reset
# $ rake db:populate
# $ rake db:test:prepare
#
#
namespace :db do

    desc "Fill database with sample data"

    # タスク
    # :environment do を実行すると、RakeタスクがUserモデルなどのローカルのRails環境にアクセスできるようになり
    # このなかでUser.createなどが実行できるようになる
    task populate: :environment do

        #アドミンユーザーをひとり作成
        # ! をつけると、ユーザーが無効な場合にfalseを返すのではなく例外を発生させる

        User.create!(name: "Example User",
                     email: "itoz@itoz.jp",
                     password: "aaaaaa",
                     password_confirmation: "aaaaaa",
                     admin: true)

        #ランダムなユーザーを大量に生成
        99.times do |n|
            name = Faker::Name.name
            email = "example#{n+1}@railstutorial.jp"
            password ="password"
            User.create!(
                name: name,
                email: email,
                password: password,
                password_confirmation: password,
            )
        end

        users = User.all(limit: 6)
        50.times do
            content = Faker::Lorem.sentence(5)
            users.each { |user| user.microposts.create!(content: content) }
        end
    end
end

# namespace :db do
#     desc "Fill database with sample data"
#     task populate: :environment do
#         User.create!(name: "Example User",
#                      email: "example@railstutorial.jp",
#                      password: "foobar",
#                      password_confirmation: "foobar")
#         99.times do |n|
#             name  = Faker::Name.name
#             email = "example-#{n+1}@railstutorial.jp"
#             password  = "password"
#             User.create!(name: name,
#                          email: email,
#                          password: password,
#                          password_confirmation: password)
#         end
#     end
# end