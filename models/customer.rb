require_relative('../db/sql_runner.rb')

class Customer

attr_reader :id
attr_accessor :name, :funds

  def initialize(info)
    @name = info["name"]
    @funds = info["funds"]
    @id = info["id"].to_i if info["id"]
  end

  def self.all
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql, values)
    result = self.map_items(customers)
    return result
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES($1, $2) RETURNING id"
    values = [@name, @funds]
    customers = SqlRunner.run(sql, values).first
    @id = customers['id'].to_i
  end

  def delete(id)
    sql = "DELETE FROM customers WHERE id =$1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE customers SET(name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.map_items(customer_data)# just not to repeat the .map in every method
    result = customer_data.map {|customer| Customer.new(customer)}
    return result
  end

  def films
    sql = "SELECT films.* FROM films INNER JOIN tickets ON tickets.film_id = films.id
    WHERE tickets.customer_id =$1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    result = films.map {|film_h| Film.new(film_h)}
    return result
  end


end
