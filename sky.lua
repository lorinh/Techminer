----------------
---sky
----------------
--draws the sky in the background during gameplay
----------------

sky = {}

function sky.init()
	sky.cloudOffset = 0
	sky.cloudVelocity = .02
end

function sky.drawClouds()
	sky.cloudOffset = sky.cloudOffset+sky.cloudVelocity
	sky.cloudOffset = sky.cloudOffset%1280
	love.graphics.draw(images.Clouds,sky.cloudOffset+1280,0,nil,1,screenSize.Y/800)
	love.graphics.draw(images.Clouds,sky.cloudOffset,0,nil,1,screenSize.Y/800)
	love.graphics.draw(images.Clouds,sky.cloudOffset-1280,0,nil,1,screenSize.Y/800)
end

function sky.draw()
	local percent = (love.timer.getTime()%(60*30))/(60*30)*6
	
	local parabola = -(percent-3)^2+6
	
	local time = parabola
	local offset = percent
	
	local parabola = parabola/4
	
	
	if parabola<0 then
		parabola = 0
	end
	if parabola > 1 then
		parabola = 1
	end
	
	percent = parabola
	
	love.graphics.setColor(255,255,255)
	love.graphics.draw(images.Stars,0,0,nil,screenSize.X/1200,screenSize.Y/920)
	love.graphics.setColor(255,255,255,percent*255)
	--love.graphics.draw(images.Clouds,0,0,nil,screenSize.X/1200,screenSize.Y/800)
	sky.drawClouds()
	love.graphics.setColor(255,255,255)
	
	if backpack.show then
		local t = ((time+3)/9)*12
		if offset > 3 then
			t = 12-t
		else
			t = t
		end
		local seconds = tostring(math.floor(((t-math.floor(t))*60)))
		if #seconds == 1 then
			seconds = '0' .. seconds
		end
		love.graphics.print(math.floor(t) .. ':' .. seconds,screenSize.X/2-30,100)
	end
end