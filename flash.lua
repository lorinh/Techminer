--------------
--testing flash block
--------------

local function animate(x,y,scaleX,scaleY,data)
	if not data then
		data = {}
		data.frame = 1
	end
	data.frame = data.frame+.3
	love.graphics.draw(images['Flash' .. math.floor(data.frame)],x,y,nil,scaleX,scaleY)
	if data.frame > 2.6 then
		data.frame = 1
	end
	return data
end

flash = {}
flash.init = function()
	blockAnimation.addAnimation('Flash',animate)
end