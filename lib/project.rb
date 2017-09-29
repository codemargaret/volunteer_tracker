class Project
  attr_accessor :title
  attr_reader :id

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def save
    saved_project = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = saved_project.first.fetch("id").to_i
  end

  def ==(another_project)
    self.title().==(another_project.title()).&(self.id().==(another_project.id()))
  end

  def self.all
    returned_projects = DB.exec("SELECT * from projects;")
    projects = []
    returned_projects.each() do |project|
      title = project.fetch("title")
      id = project.fetch("id").to_i
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
  end

  def self.find(id)
    found_projects = DB.exec("SELECT * FROM projects WHERE id = #{id};")
    title = found_projects.first.fetch("title")
    Project.new({:title => title, :id => id})
  end

  def volunteers
    found_volunteers = DB.exec("SELECT * from volunteers WHERE project_id = #{self.id()};")
    project_volunteers = []
    found_volunteers.each() do |volunteer|
      name = volunteer.fetch("name")
      project_id = volunteer.fetch("project_id").to_i
      id = volunteer.fetch("id").to_i
      project_volunteers.push(Volunteer.new(:name => name, :project_id => project_id, :id => id))
    end
    project_volunteers
  end

  def update(attributes)
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = '#{self.id()}';")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id()};")
  end
end #Project class
