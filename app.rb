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
