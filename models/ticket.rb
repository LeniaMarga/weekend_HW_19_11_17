require_relative('../db/sql_runner.rb')
require_relative('film.rb')
require_relative('customer.rb')

class Ticket

  attr_reader :id
  attr_accessor :film_id, :customer_id

  def initialize(info)
    @film_id = info["film_id"]
    @customer_id = info["customer_id"]
    @id = info["id"].to_i if info["id"]
  end

  def self.all
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql, values)
    result = self.map_items(tickets)
    return result
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    values = []
    SqlRunner.run(sql, values)
  end

  def save()
    sql = "INSERT INTO tickets (film_id, customer_id) VALUES($1, $2) RETURNING id"
    values = [@film_id, @customer_id]
    tickets = SqlRunner.run(sql,values).first
    @id = tickets['id'].to_i
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id =$1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE tickets SET(film_id, customer_id) = ($1, $2) WHERE id = $3"
    values = [@film_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end


  def self.map_items(ticket_data)# just not to repeat the .map in every method
    result = ticket_data.map {|ticket| Ticket.new(ticket)}
    return result
  end

  # start test in sql postico first
  # our sql query starts in the most remote table (locations) and ends with the table we are in (users):
  # SELECT locations.* FROM locations
  # INNER JOIN visits ON visits.location_id = locations.id
  # WHERE visits.user_id = 6 --- random entry
  def film
   sql = "SELECT * FROM films WHERE id = $1"
   values = [@film_id]
   film = SqlRunner.run(sql, values)
   return film.map {|film_h| Film.new(film_h)}
  end

  def customer
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values)
    return customer.map {|customer_h| Customer.new(customer_h)}
  end

  def purchase
    sql = 'SELECT customers.*, customer.funds AS funds, films.price FROM films
    INNER JOIN tickets ON tickets.customer_id = customers.id
    INNER JOIN films ON films.id = tickets.film_id
    SET customer.funds -= film.price
    WHERE tickets.id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end


end
