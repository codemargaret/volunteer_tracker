require "sinatra"
require "sinatra/reloader"
also_reload "lib/**/*.rb"
require "./lib/project"
require "./lib/volunteer"
require "pg"
require "pry"

DB = PG.connect({:dbname => 'volunteer_tracker_test'})

#Show homepage with project list
get("/") do
  @projects = Project.all()
  erb(:index)
end

#Add a new project
post("/") do
  title = params.fetch("title")
  new_project = Project.new({:title => title, :id => nil})
  new_project.save
  redirect "/"
end

#Show project detail page with list of volunteers
get("/projects/:id") do
  @project_id = params[:id]
  @project = Project.find(params[:id])
  @volunteers = @project.volunteers()
  erb(:project_details)
end

#Show page to update and delete individual project
get("/projects/:id/edit") do
  @project_id = params[:id]
  @project = Project.find(params[:id])
  erb(:edit)
end

post "/projects/:id/volunteers" do
  project_id = params[:id]
  @project = Project.find(params[:id])
  name = params["name"]
  volunteer = Volunteer.new(:project_id => @project.id, :name => name)
  volunteer.save
  redirect "/projects/#{@project.id}"
end

#Change the name of a project
patch("/projects/:id/edit") do
  project = Project.find(params[:id])
  title = params.fetch("title")
  project.update({:title => title})
  redirect "/"
end

#Delete a project
delete "/projects/:id/edit" do
  project = Project.find(params[:id])
  project.delete
  redirect "/"
end

#See volunteer details
get "/volunteer/:id" do
  @volunteer = Volunteer.find(params[:id])
  erb :volunteer_details
end

#Change the name of a volunteer
patch("/volunteer/:id/edit") do
  name = params["name"]
  @volunteer = Volunteer.find(params["id"].to_i)
  @volunteer.update({:name => name})
  redirect "/volunteer/#{@volunteer.id}"
end
