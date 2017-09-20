require 'sinatra'
require 'json'
require_relative 'models/data_mapper'

set :views, settings.root + '/views'

# sets root as the parent-directory of the current file
#set :root, File.join(File.dirname(__FILE__), '..')
# sets the models directory
#set :models, Proc.new { File.join(root, "models") }
# sets the views directory
#set :views, Proc.new { File.join(root, "views") }

#End Points ------

# application root
get('/') do
  sensors = Sensor.all
  erb(:index, locals: { sensors: sensors })
end

# render a search for sensor form
get('/sensors/search') do
  erb(:search_sensor)
end

# search for a new sensor
post('/sensors') do
  new_sensor = Sensor.new
  new_sensor.name = params[:name]
  new_sensor.save
  redirect('/')
end

# render the sensor of concern to the browser
get('/sensors/:id/edit') do
  sensor = Sensor.get(params[:id])
  erb(:edit_sensor, locals: { sensor: sensor })
end

# edit a sensor
put('/sensors/:id') do
  sensor = Sensor.get(params[:id])
  sensor.name = params[:name]
  sensor.save
  redirect('/')
end

# delete sensor
delete('/sensors/:id') do
  Sensor.get(params[:id]).destroy
  redirect('/')
end
