require_relative "../config/environment.rb"

class Student
    # Accessor macros
    attr_accessor :name, :grade
    attr_reader :id

    # Initialize macro
    def initialize(name, grade, id = nil)
        @id = id
        @name = name
        @grade = grade    
    end

    # Class methods
    def self.new_from_db(row)
        self.new(row[1], row[2], row[0])
    end

    def self.all
        DB[:conn].execute("SELECT * FROM students;")
    end

    def self.create_table
        DB[:conn].execute(
            "CREATE TABLE IF NOT EXISTS students (
                id INT PRIMARY KEY,
                name TEXT,
                grade TEXT
                );" )
    end

    def self.drop_table
        DB[:conn].execute("DROP TABLE IF EXISTS students;")
    end

    def self.create(name, grade)
        self.new(name, grade).save
    end

    def self.find_by_name(name)
        row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).first
        self.new_from_db(row)
    end

    # Instance methods
    def update
        DB[:conn].execute(
            "UPDATE students
            SET name = ?, grade = ?
            WHERE id = ?;",
            self.name, self.grade, self.id)
    end

    def save
        if self.id
            self.update
        else
            DB[:conn].execute(
                "INSERT INTO students (name, grade)
                VALUES ( ?, ?);",
                self.name, self.grade)
            @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
        end
    end

end

# binding.pry