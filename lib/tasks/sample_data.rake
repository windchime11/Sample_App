require 'faker'

namespace :db do

   desc "Fill database with sample data"
   task :populate => :environment do
   	Rake::Task['db:reset'].invoke
	make_users
	make_microposts
	make_relationships
   end
end

def make_users 
	admin = User.create!(:name => "Fictional User",
		     :email => "qwert123@mymail.com",
                     :password => "foobar123",
                     :password_confirmation => "foobar123")
	admin.toggle!(:admin)
	nonadmin = User.create!(:name => "Non Admin User",
		     :email => "qwert1234@mymail.com",
                     :password => "foobar123",
                     :password_confirmation => "foobar123")

        99.times do |n|
	   name = Faker::Name.name
	   email = "qwert-#{n+1}@mymail.com"
	   password = "foobar123"
	   User.create!(:name => name, :email => email, 
	   		      :password => password, 
			      :password_confirmation => password)
        end 
end

def make_microposts 
	User.all(:limit=>6).each do |user|
	   50.times do |n|
	     user.microposts.create!(:title => "This is post \##{n+1}",
	     :content => Faker::Lorem.sentence(5))
	   end
	end

end

def make_relationships
    users = User.all
    user = users.first
    following = users[1..50]
    follower = users[4..40]
    following.each { |f| user.follow!(f)}
    follower.each { |f| f.follow!(user)}
end
