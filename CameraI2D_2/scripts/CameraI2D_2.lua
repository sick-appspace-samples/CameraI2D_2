-- Start of Global Scope -------------------------------------------------------

-- IP address of the connected camera, has to match the actual camera
local CAM1_IP = '192.168.0.3'

-- Create and configure camera
local config = Image.Provider.RemoteCamera.GigEVisionConfig.create()
config:setFrameRate(5)
config:setShutterTime(5000)

local cam1 = Image.Provider.RemoteCamera.create()
cam1:setType("GIGE_VISIONCAM")
cam1:setIPAddress(CAM1_IP)
cam1:setConfig(config)

-- Create viewer
local viewer = View.create('viewer2d')

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

--@main()
local function main()
  -- Connect to camera and start image acquisition
  local isConnected = cam1:connect()
  if isConnected then
    cam1:start()
    print('Connection to camera successful')
  else
    print('Connection to camera failed')
  end
end
--The registration is part of the global scope which runs once after startup
Script.register('Engine.OnStarted', main)

--@handleOnNewImage(image:Image,sensordata:SensorData)
local function handleOnNewImage(image, sensordata)
  -- View downsampled image in the 2D viewer
  local downsampledImage = image:resizeScale(0.25)
  viewer:addImage(downsampledImage)
  viewer:present()

  -- Print additional sensor data to the console
  print("Frame number: " .. sensordata:getFrameNumber() .. " Timestamp: " .. sensordata:getTimestamp())
end
--The registration is part of the global scope which runs once after startup
Image.Provider.RemoteCamera.register(cam1, 'OnNewImage', handleOnNewImage)

--End of Function and Event Scope-----------------------------------------------