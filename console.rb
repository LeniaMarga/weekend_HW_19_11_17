require('pry-byebug')
require('pp')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

Ticket.delete_all
Film.delete_all
Customer.delete_all

film1 = Film.new({'title'=> 'Men in Black',
  'price'=> 10})
film2 = Film.new({'title'=> 'Star Wars 3',
  'price'=> 12})
customer1= Customer.new({'name'=> 'Eleni',
  'funds'=> 30})
customer2= Customer.new({'name'=> 'Giorgos',
  'funds'=> 40})
ticket1 = Ticket.new({'film_id'=> film2.id,'customer_id'=> customer1.id})
ticket2 = Ticket.new({'film_id'=> film2.id,'customer_id'=> customer2.id})

film1.save
film2.save
customer1.save
customer2.save
ticket1.save
ticket2.save

customer1.funds = '40'
customer1.update

ticket1.customer
ticket1.film

customer1.films
film2.customers

binding.pry
nil
