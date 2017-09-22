require "sinatra"
require "sinatra/reloader"
also_reload "lib/**/*.rb"
require "./lib/project"
require "./lib/volunteer"
require "pg"
require "pry"

DB = PG.connect({:dbname => 'volunteer_tracker_test'})

get("/") do
  erb(:index)
end

post("/") do
  title = params["title"]
  project_title = {"title" => title}
  new_project = Project.new(project_title)
  new_project.add_project()
  redirect "/"
end
