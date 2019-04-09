----------------
---generate terrain
----------------

terrain = {}

function terrain.init()
	terrain.min = 0
	terrain.max = 0
	terrain.spawn = Vector2.new()
end

function terrain.whiteLine(x1,x2)
	local whiteLine = {}
	for i = x1,x2 do
		whiteLine[i] = random.range(0,1000,i,5,1)/1000
	end
	return whiteLine
end

function terrain.gaussian(whiteLine)
	for dotIndex,dotValue in pairs(whiteLine) do
		local value = 0
		for i = -3,3 do
			if whiteLine[dotIndex+i] then
				value = value + whiteLine[dotIndex+i]/7
			end
		end
		whiteLine[dotIndex] = value
	end
	return whiteLine
end

function terrain.getMinMax()
	local min = 0
	local max = 0
	for xIndex,xValue in pairs(map:getMap()) do
		if xIndex < min then
			min = xIndex
		elseif xIndex > max then
			max = xIndex
		end
	end
	print('Min and Max of terrain are: ' .. min .. ' , ' .. max)
	terrain.min = min
	terrain.max = max
end
	

function terrain.generate(x1,x2,new)--max is 10, min is -5
	if x1 < terrain.min then
		terrain.min = x1
	elseif x2 > terrain.max then
		terrain.max = x2
	end
	local whiteLine = terrain.whiteLine(x1,x2)
	local whiteLine = terrain.gaussian(whiteLine)
	for xPos,value in pairs(whiteLine) do
		local value = value*30-5
		local value = value-value%1
		for y = 5,-value,-1 do
			--print(y,value)
			if y == -value then
				map:setPoint(xPos,y,'Grass')
				map:backgroundSetPoint(xPos,y,'Dirt')
			else
				map:setPoint(xPos,y,'Dirt')
				map:backgroundSetPoint(xPos,y,'Dirt')
			end
		end
		if xPos == 0 and new then
			--print('Height is: ' .. value)
			Camera = Vector2.new(0,value*50+50+300)
			terrain.spawn = Camera+Vector2.new(0,0)
			--Camera = Vector2.new(0,2000)--Vector2.new(0,-value-450)
		end
	end
	trees.createArea(x1,x2)
end

function terrain.autoGenerate()
	if -Camera.X/50 < terrain.min+50 then
		terrainChannelRequest:push(terrain.min-50)
		terrainChannelRequest:push(terrain.min)
		terrainThread:start()
		terrain.min = terrain.min-50
		--terrain.generate(terrain.min-50,terrain.min,false)
	elseif -Camera.X/50 > terrain.max-50 then
		terrainChannelRequest:push(terrain.max)
		terrainChannelRequest:push(terrain.max+50)
		terrainThread:start()
		terrain.max = terrain.max+50
		--terrain.generate(terrain.max,terrain.max+50,false)
	end
	for i = 1,2 do
		if terrainChannelReturn:getCount() >= 3 then
			--print('Stack size is:' .. terrainChannelReturn:getCount())
			local x = terrainChannelReturn:pop()
			--print('X value is: ' .. x)
			local y = terrainChannelReturn:pop()
			--print('Y value is: ' .. y)
			local value = terrainChannelReturn:pop()
			--print('Value is: ' .. value)
			map:setPoint(x,y,value,true)
		end
	end
end

