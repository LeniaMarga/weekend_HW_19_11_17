require_relative('../db/sql_runner.rb')

class Film

attr_reader :id
attr_accessor :title, :price

  def initialize(info)
    @title = info["title"]
    @price = info["price"]
    @id = info["id"].to_i if info["id"]
  end

  def self.all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql, values)
    result = self.map_items(films)
    return result
  end

  def self.delete_all
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES($1, $2) RETURNING id"
    values = [@title, @price]
    films = SqlRunner.run(sql, values).first
    @id = films['id'].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id =$1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE films SET(title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def self.map_items(film_data)# just not to repeat the .map in every method
    result = film_data.map {|film| Film.new(film)}
    return result
  end

  def customers
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON tickets.customer_id = customers.id
    WHERE tickets.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    result = customers.map {|customer_h| Customer.new(customer_h)}
    return result
  end

end
