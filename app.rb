require "sinatra"
require "sinatra/reloader"
also_reload "lib/**/*.rb"
require "./lib/project"
require "./lib/volunteer"
require "pg"
require "pry"

DB = PG.connect({:dbname => 'volunteer_tracker_test'})

get("/") do
  @project_list = Project.all()
  erb(:index)
end

post("/") do
  title = params.fetch("title")
  new_project = Project.new({:title => title, :id => nil})
  new_project.save
  new_project.add_project
  redirect "/"
end

get("/project/:id") do
  @project = Project.find(params[:id])
  @volunteers = @project.volunteers()
  erb(:project_details)
end

get("/edit") do
  erb(:edit)
end

# post("/project/:id") do
#   @project = Project.find(params[:id])
#   name = params.fetch("name")
#   new_volunteer = Volunteer.new({:name => name, :project_id => @project, :id => nil})
#   new_volunteer.save
#   redirect "/project/:id"
# end
