# By using the symbol :user, we get Factory girl to simulate the User model
Factory.define :user do |user|
  user.name              "Big Mouth Zhuzhu"
  user.email             "abc123456@gmail.com"
  user.password          "foobar123"
  user.password_confirmation "foobar123"
end

#Not sure what is the use of this.
Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.title "Fb"
  micropost.content "foo a bar"
  micropost.association :user
end
