class Task
  attr_reader :id
  attr_accessor :title, :description, :done

  def initialize(attributes = {})
    @id = attributes[:id]
    @title = attributes[:title]
    @description = attributes[:description]
    # We have to set done as 1 or 0, as sqlite doesn't handle true/false boolean values
    @done = attributes[:done] || 0
  end

  def self.find(id)
    row = DB.execute("SELECT * FROM tasks WHERE id = ?", id).first
    row.nil? ? nil : Task.new(row.transform_keys(&:to_sym))
  end

  def self.all
    rows = DB.execute("SELECT * FROM tasks")
    rows.map do |row|
      Task.new(row.transform_keys(&:to_sym))
    end
  end

  def save
    if @id.nil?
      DB.execute("INSERT INTO tasks (title, description, done) VALUES (?, ?, ?)", @title, @description, @done)
      @id = DB.last_insert_row_id
    else
      DB.execute("UPDATE tasks SET title = ?, description = ?, done = ? WHERE id = ?", @title, @description, @done, @id)
    end
  end

  def destroy
    DB.execute("DELETE FROM tasks WHERE id = ?", @id)
  end
end
