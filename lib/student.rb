require_relative "../config/environment.rb"
require 'pry'

class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY, " +
    "name TEXT,grade FLOAT);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"
    DB[:conn].execute(sql)
  end

  def save
    if(self.id)
      self.update
    else
      sql = "INSERT INTO students (name,grade) VALUES(?,?)"
      DB[:conn].execute(sql,self.name,self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name,grade)
    n = Student.new(name,grade).save
    n
  end

  def self.new_from_db(attrs)
    Student.new(attrs[0],attrs[1],attrs[2])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    self.new_from_db(DB[:conn].execute(sql,name)[0])
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    lm = DB[:conn].execute(sql,self.name,self.grade,self.id)
  end

end
