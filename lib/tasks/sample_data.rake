require 'faker'

namespace :db do

   desc "Fill database with sample data"
   task :populate => :environment do
   	Rake::Task['db:reset'].invoke
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
end