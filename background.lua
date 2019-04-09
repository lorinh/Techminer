----------------
---draws the background for main menu.
----------------

backgroundMenu = {}

 function backgroundMenu.init()
	backgroundMenu.cloudOffset = 0
	backgroundMenu.cloudVelocity = .4
	backgroundMenu.images = {}
	backgroundMenu.images.backgroundMenu = love.graphics.newImage("Images/BackgroundMenu.png")
	backgroundMenu.images.clouds = love.graphics.newImage("Images/BlurredClouds.png")
	--backgroundMenu.images.fade = love.graphics.newImage("Images/Fade.png")
end

 function backgroundMenu.draw()
	backgroundMenu.cloudOffset = backgroundMenu.cloudOffset+backgroundMenu.cloudVelocity
	backgroundMenu.cloudOffset = backgroundMenu.cloudOffset%1140
	love.graphics.draw(backgroundMenu.images.clouds,backgroundMenu.cloudOffset+1140,0,nil,1,screenSize.Y/920)
	love.graphics.draw(backgroundMenu.images.clouds,backgroundMenu.cloudOffset,0,nil,1,screenSize.Y/920)
	love.graphics.draw(backgroundMenu.images.clouds,backgroundMenu.cloudOffset-1140,0,nil,1,screenSize.Y/920)
	
	love.graphics.draw(backgroundMenu.images.backgroundMenu,0,0,nil,screenSize.X/1200,screenSize.Y/920)

	--love.graphics.draw(backgroundMenu.images.fade,screenSize.X/4,300,nil,screenSize.X/3840,(screenSize.Y-200)/7000)
end