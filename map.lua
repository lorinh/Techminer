----------------
---map
----------------
--makes the map into an object
----------------

map = {}

map.background = {}
map.map = {}
map.data = {}
map.light = {}

local selectiveRender = true

--[[map.init = function()
	terrain.generate(-100,100,true)
end]]

function map:generate()
	terrain.generate(-100,100,true)
end

function map:reset()
	map.map = {}
	map.background = {}
end

function map:getMap()
	return map.map
end

function map:getScreenMap(borderX,borderY)
	local CameraX = Camera.X
	local CameraY = Camera.Y
	local percent = 450/screenSize.Y
	local screenSizeY = screenSize.Y*(1/zoom)
	local screenSizeX = screenSize.X*(1/zoom)

	local CameraX = CameraX+(screenSizeX-screenSize.X)/2
	local CameraY = CameraY-450+percent*screenSizeY

	local xStart = -(CameraX-CameraX%50)/50
	local yStart = -(CameraY-CameraY%50)/50-4

	local xExtend = (screenSizeX-screenSizeX%50)/50
	local yExtend = (screenSizeY-screenSizeY%50)/50+5

	local screenMap = {}

	for xIndex = xStart-borderX,xStart+borderX+xExtend do
		for yIndex = yStart-borderY,yStart+borderY+yExtend do
			if not screenMap[xIndex] then
				screenMap[xIndex] = {}
			end
			if map.map[xIndex] and map.map[xIndex][yIndex] then
				screenMap[xIndex][yIndex] = map.map[xIndex][yIndex]
			end
		end
	end
	return screenMap
end

function map:getIndexMap()
	local map = map:getMap()
	local new = {}
	for xIndex,xValue in pairs(map) do
		for yIndex,yValue in pairs(xValue) do

			if not new[tonumber(xIndex)] then
				new[tonumber(xIndex)] = {}
			end

			if new[tonumber(xIndex)][tonumber(yIndex)] == nil then
				new[tonumber(xIndex)][tonumber(yIndex)] = data.itemInfo[yValue].index
			else
				print('Found duplicate entry',xIndex,yIndex,yValue)
			end
		end
	end
	return new
end

function map:getBackground()
	return map.background
end

function map:getIndexBackground()
	local map = map:getBackground()
	local new = {}
	for xIndex,xValue in pairs(map) do
		for yIndex,yValue in pairs(xValue) do
			if not new[xIndex] then
				new[xIndex] = {}
			end
			if type(xIndex) == 'string' or type(yIndex) == 'string' then
				print('ERROR, found string in backgroundmap.')
				print(xIndex,yIndex,yValue)
			end
			if not data.itemInfo[yValue] then
				print('ERROR: unknown block in background table called ' .. yValue .. ' at position: ' .. tostring(xIndex) .. ' : ' .. tostring(yIndex))
			else
				new[xIndex][yIndex] = data.itemInfo[yValue].index
			end
		end
	end
	return new
end

function map:setMultiBlock(x,y,value,blockData)
	for offsetX = 1,blockData.size.X do
		for offsetY = 1,blockData.size.Y do
			local offsetX = offsetX - 1
			local offsetY = offsetY - 1
			if not map.map[x+offsetX] then
				map.map[x+offsetX] = {}
			end
			map:addPhysics(x+offsetX,y+offsetY,'_' .. value)
			map.map[x+offsetX][y+offsetY] = '_' .. value
			map:updateLight(x+offsetX,y+offsetY,value)
		end
	end
	map:addPhysics(x,y,value)
	map.map[x][y] = value
	map:checkData(x,y,value)
end

function map:setRawPoint(x,y,value)
	blockIndexing.addBlock(value,x,y)
	local blockData = data.itemInfo[value]
	if not map.map[x] then
		map.map[x] = {}
	end
	map:addPhysics(x,y,value)
	map.map[x][y] = value
end

function map:setData(x,y,value)
	if not map.data[x] then
		map.data[x] = {}
	end
	map.data[x][y] = value
end

function map:getData(x,y)
	if not map.data[x] then
		map.data = {}
	end
	return map.data[x][y]
end

function map:checkData(x,y,value)
	if value == 'air' then
		map:setData(x,y,nil)
	end
end

function map:setPoint(x,y,value,ignoreLight)
	if value ~= 'nil' then
		blockIndexing.addBlock(value,x,y)
		local blockData = data.itemInfo[value]

		if blockData.size then
			map:setMultiBlock(x,y,value,blockData)
		else
			if not map.map[x] then
				map.map[x] = {}
			end
			map:addPhysics(x,y,value)
			if not map.map[x][y] == nil then
				blockIndexing.removeBlock(map.map[x][y],x,y)
			end
			map.map[x][y] = value
			map:checkData(x,y,value)
			if selectiveRender and not ignoreLight then
				map:updateLight(x,y,value)
			end
		end
		if not ignoreLight then
			worldCraft.run()
		end
	else
		print('ERROR, ATTEMPTED TO SET BLOCK AT: ' .. x .. ':' .. y .. ' to nil')
	end
end

function map:addPhysics(x,y,value)
	local blockString = tostring(x)..':'..tostring(y)
	if physics.world:hasItem(blockString) then
		if not map.map[x][y] then
			physics.world:remove(blockString)
			if data.itemInfo[value].physics == true then
				physics.world:add(blockString,x*50,y*50+450,50,50)
			end
		end
		-- block exists
		if map.map[x][y] and data.itemInfo[map.map[x][y]].physics == false and data.itemInfo[value].physics == true then
			physics.world:remove(blockString)
			physics.world:add(blockString,x*50,y*50+450,50,50)
		elseif data.itemInfo[value].physics == false then
			physics.world:remove(blockString)
		end
	elseif data.itemInfo[value].physics == true then
		physics.world:add(blockString,x*50,y*50+450,50,50)
	end
end

function map:backgroundSetPoint(x,y,value)
	if y > -4 then
		if map.background[x] == nil then
			map.background[x] = {}
		end
		if value == 'Dirt' or value == 'Grass' or string.sub(value,1,4) == 'Dirt' then
			map.background[x][y] = 'Dirt'
		else
			map.background[x][y] = 'Stone'
		end
	end
end

function map:getNameFromIndex(index)
	for i,v in pairs(data.itemInfo) do
		if v.index == index then
			return i
		end
	end
end

function map:setRawPointBackground(x,y,value)
	if not map.background[x] then
		map.background[x] = {}
	end
	map.background[x][y] = value
end

function map:loadBackground(value)
	for xIndex,xValue in pairs(value) do
		for yIndex,yValue in pairs(xValue) do
			local value = map:getNameFromIndex(yValue)
			map:setRawPointBackground(tonumber(xIndex),tonumber(yIndex),value)
		end
	end
end

function map:load(value)
	for xIndex,xValue in pairs(value) do
		for yIndex,yValue in pairs(xValue) do
			local value = map:getNameFromIndex(yValue)
			map:setRawPoint(tonumber(xIndex),tonumber(yIndex),value)
		end
	end
end

local vectorTableHigh = {{X = 0,Y = 1},{X = 0,Y = -1},{X = -1,Y = 0},{X = 1,Y = 0}}
--						{Vector2.new(0,1),Vector2.new(0,-1),Vector2.new(-1 ,0),Vector2.new(1, 0)}
local vectorTableMed = {{X = 1,Y = 1},{X = -1,Y = 1},{X = -1,Y = -1},{X = 1,Y = -1}}
--local vectorTableMed     = {Vector2.new(1,1),Vector2.new(-1,1),Vector2.new(-1,-1),Vector2.new(1,-1)}
local vectorTableLow = {{X = 2,Y = 0},{X = -2,Y = 0},{X = 0,Y = 2},{X = 0,Y = -2}}
--local vectorTableLow     = {Vector2.new(2,0),Vector2.new(-2,0),Vector2.new( 0, 2),Vector2.new(0,-2)}
local vectorTableLowest = {{X = 2,Y = 2},{X = -2,Y = 2},{X = 2,Y = -2},{X = 2,Y = -2}}
--local vectorTableLowest  = {Vector2.new(2,2),Vector2.new(-2,2),Vector2.new( 2,-2),Vector2.new(2,-2)}

function map:checkAir(x,y)
	local light = map.light

	if not light[x] then
		light[x] = {}
	end
	if not light[x][y] then
		light[x][y] = map:getLight(x,y)
	end
	return light[x][y]
end

function map:updateLight(x,y,value)
	local light = map.light

	if light[x] then
		light[x][y] = nil
	end
	for i,v in pairs(vectorTableHigh) do
		local x = x+v.X
		local y = y+v.Y
		if light[x] then
			light[x][y] = nil
		end
	end
	for i,v in pairs(vectorTableMed) do
		local x = x+v.X
		local y = y+v.Y
		if light[x] then
			light[x][y] = nil
		end
	end
	for i,v in pairs(vectorTableLow) do
		local x = x+v.X
		local y = y+v.Y
		if light[x] then
			light[x][y] = nil
		end
	end
	for i,v in pairs(vectorTableLowest) do
		local x = x+v.X
		local y = y+v.Y
		if light[x] then
			light[x][y] = nil
		end
	end
end

function map:getLight(x,y)
	local screenMap = map:getMap()
	--local screenMap = map:getScreenMap(5,5)

	if screenMap[x] and (screenMap[x][y] == 'air' or screenMap[x][y] == nil) then
		return 0
	elseif not screenMap[x] then
		return 0
	end

	for i,v in pairs(vectorTableHigh) do
		local x = x+v.X
		local y = y+v.Y
		local block = screenMap[x] and screenMap[x][y]
		if block then
			if block == 'air' or data.itemInfo[block].solid == false then
				return 0
			end
		else
			return 0
		end
	end
	
	for i,v in pairs(vectorTableMed) do
		local x = x+v.X
		local y = y+v.Y
		local block = screenMap[x] and screenMap[x][y]
		if block then
			if block == 'air' or data.itemInfo[block].solid == false then
				return .3
			end
		else
			return .3
		end
	end
	

	for i,v in pairs(vectorTableLow) do
		local x = x+v.X
		local y = y+v.Y
		local block = screenMap[x] and screenMap[x][y]
		if block then
			if block == 'air' or data.itemInfo[block].solid == false then
				return .6
			end
		else
			return .6
		end
	end

	for i,v in pairs(vectorTableLowest) do
		local x = x+v.X
		local y = y+v.Y
		local block = screenMap[x] and screenMap[x][y]
		if block then
			if block == 'air' or data.itemInfo[block].solid == false then
				return .9
			end
		else
			return .9
		end
	end

	return 1
end

function map:render()
	love.graphics.scale(zoom)
	local mapObj = map
	local background = map:getBackground()
	local map = map:getMap()
	love.graphics.setColor(0,0,0)

	local CameraX = Camera.X
	local CameraY = Camera.Y--+450
	local percent = 450/screenSize.Y
	local screenSizeY = screenSize.Y*(1/zoom)
	local screenSizeX = screenSize.X*(1/zoom)

	--print('ScreenSize is:' .. screenSizeX-screenSize.X)
	local CameraX = CameraX+(screenSizeX-screenSize.X)/2
	local CameraY = CameraY-450+percent*screenSizeY

	--local CameraY = CameraY-450
	--love.graphics.rectangle('fill',0,Camera.Y+300,screenSize.X,screenSize.Y)

	local xStart = -(CameraX-CameraX%50)/50
	local yStart = -(CameraY-CameraY%50)/50-4

	local xExtend = (screenSizeX-screenSizeX%50)/50
	local yExtend = (screenSizeY-screenSizeY%50)/50+5

	local setColor = love.graphics.setColor

	setColor(100,100,100)

	for xIndex = xStart-1,xStart+xExtend do
		for yIndex = yStart-yExtend,yStart+yExtend do
			if background[xIndex] and background[xIndex][yIndex] then
				local value = background[xIndex][yIndex]
				if images[value .. 'Dark'] then
					love.graphics.draw(images[value .. 'Dark'],xIndex*50+CameraX,yIndex*50+CameraY+450,nil,.5,.5)
				else
					print('ERROR: Unable to load the dark version of ' .. value)
				end
			end
		end
	end

	setColor(255,255,255)

	for xIndex = xStart-1,xStart+xExtend do
		for yIndex = yStart-yExtend,yStart+yExtend do
			local value = map[xIndex] and map[xIndex][yIndex]
			if value ~= 'air' and value then
				local posX = xIndex*50+CameraX
				local posY = yIndex*50+CameraY+450
				if posY >= -100 and posY < screenSizeY then
					if string.sub(value,1,1) ~= '_' then
						if data.itemInfo[value].animation ~= true then
							love.graphics.draw(images[value],posX,posY,nil,.5 * (data.itemInfo[value].scale and data.itemInfo[value].scale or 1),.5 * (data.itemInfo[value].scale and data.itemInfo[value].scale or 1))
						else
							blockAnimation.playAnimation(value,posX,posY,.5,.5,Vector2.new(xIndex,yIndex))
						end
					end
					if coreFunctions.mine.block.X == xIndex and coreFunctions.mine.block.Y == yIndex then			
						love.graphics.draw(images.breakingAnimation['breaking'..tostring(math.ceil(coreFunctions.mine.frame/30))],posX,posY,nil,.5,.5)
					end	
				end
			end
		end
	end

	if selectiveRender then
		for xIndex = xStart-1,xStart+xExtend do
			for yIndex = yStart-yExtend,yStart+yExtend do
				local posX = xIndex*50+CameraX
				local posY = yIndex*50+CameraY+450
				if posY >= -100 and posY < screenSizeY then
					setColor(0,0,0,255*mapObj:checkAir(xIndex,yIndex))
					love.graphics.rectangle('fill',posX,posY,50,50)
				end
			end
		end
	end
	love.graphics.scale(1/zoom)
end

--[[

map = {}
map[1] = {}

local meta = {

	__newindex = function(self,index,value) 
		rawset(self.data,index,{})
		rawset(self.data[index].name,value)
	end, 

	__index = function(self,index) 
		return rawget(rawget(self.data,index),'name')
	end, 

	data = {}
}

setmetatable(map[1],meta)

map[1][1] = 'air'

print(map[1][1])]]