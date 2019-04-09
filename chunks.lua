----------------
---chunk generation
----------------

chunk = {}
chunk.init = function()
	chunk.data = {}--chunks are 25x25
	chunk.queue = {}
end

local blurTable = {1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9}

--set point of a fake map
function chunk.setPoint(x,y,value,map)
	if not map[x] then
		map[x] = {}
	end
	map[x][y] = value
end

--blur the map with a simple gaussian
function chunk.gaussian(map,pos,matrix)
	local tableSize = (#matrix)^.5
	local average = 0
	for x = 1,tableSize do
		for y = 0,tableSize-1 do
			local index = x+y
			local x = pos.X+x-(tableSize-1)/2
			local y = pos.Y+y-(tableSize-1)/2
			if map[x] and map[x][y] then
				average = average+map[x][y]*matrix[index]
			end
		end
	end
	map[pos.X][pos.Y] = average
end

--check 
function chunk.checkArea(map,pos)
	local value = false
	for i,v in pairs({Vector2.new(0,1),Vector2.new(0,-1),Vector2.new(1,0),Vector2.new(-1,0)}) do
		if map[v.X+pos.X] and map[v.X+pos.X][v.Y+pos.Y] == 1 then
			value = true
		end
	end
	return value
end


--Step the gaussain map, then convert to strings
function chunk.filterStep(map,oreValue,oreName)
	local resultMap = {}
	for xIndex,xValue in pairs(map) do
		resultMap[xIndex] = {}
		for yIndex,yValue in pairs(xValue) do
			if yValue > oreValue(yIndex) then --.66 then
				yValue = 1
			else
				yValue = 0
			end
			resultMap[xIndex][yIndex] = yValue
		end
	end
	for xIndex,xValue in pairs(resultMap) do
		for yIndex,yValue in pairs(xValue) do
			if yValue == 1 then
				if chunk.checkArea(resultMap,Vector2.new(xIndex,yIndex)) then
					resultMap[xIndex][yIndex] = oreName
				else
					resultMap[xIndex][yIndex] = ''
				end
			end
		end
	end
	return resultMap
end


--apply second arg to first arg only allowing allow arg
chunk.applyOre = function(first,second,allow)
	for xIndex,xValue in pairs(second) do
		for yIndex,yValue in pairs(xValue) do
			if yValue == allow then
				if not first[xIndex] then
					first[xIndex] = {}
				end
				first[xIndex][yIndex] = yValue
			end
		end
	end
	return first
end

--create a layer filled with block
chunk.createFakeLayer = function(block)
	layer = {}
	for x = 1,25 do
		layer[x] = {}
		for y = 1,25 do
			layer[x][y] = block
		end
	end
	return layer
end

function chunk.stepDirt(sound)
	for x = 1,25 do
		for y = 1,25 do
			if sound[x][y] >= .5 then
				sound[x][y] = 'Dirt'
			else
				sound[x][y] = 'Stone'
			end
		end
	end
	return sound
end

function chunk.dirtSound(id)
	--fill table with sound
	local sound = {}
	for x = 1,25 do
		for y = 1,25 do
			chunk.setPoint(x,y,random.range(0,100,x+id.X*25,y+id.Y*25,index)/100,sound)
		end
	end
	--linear thingy
	for y = 1,25 do
		for x = 1,25 do
			sound[x][y] = sound[x][y]*((25-y)/25)
		end
	end
	sound = chunk.stepDirt(sound)
	return sound
end

--dirt gen options
--start at 100, to 125
--2d sound, linear
---in dirt gen:
--copper
--make fire to smelt copper
--make clay smelter thingy


--Create chunk at x and y position for ores
chunk.createChunk = function(id,ores)
	if not chunk.data[id.X] then
		chunk.data[id.X] = {}
	end
	chunk.data[id.X][id.Y] = {}
	local chunkOres = {}
	chunkOres = chunk.applyOre(chunkOres,chunk.createFakeLayer('Stone'),'Stone')
	local index = 0
	if id.Y <= 2 then
		if id.Y == 2 then
			chunkOres = chunk.applyOre(chunkOres,chunk.dirtSound(id),'Dirt')
		else
			--create a new layer
			chunkOres = chunk.applyOre(chunkOres,chunk.createFakeLayer('Dirt'),'Dirt')
			--loop through all the dirt ores
			for oreIndex,oreValue in pairs(data.dirtOres) do
				index = index + 1

				local ore = {}
				for x = 1,25 do
					for y = 1,25 do
						chunk.setPoint(x,y,random.range(0,100,x+id.X*25,y+id.Y*25,index)/100,ore)
					end
				end

				for xIndex,xValue in pairs(ore) do
					for yIndex,v in pairs(xValue) do
						chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
						chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
						chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
						chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
					end
				end

				ore = chunk.filterStep(ore,oreValue.func,oreIndex)

				chunkOres = chunk.applyOre(chunkOres,ore,oreIndex)
			end
		end
	else
		--loop through all the ores
		for oreIndex,oreValue in pairs(ores) do
			index = index+1
			--create 2D map for the new ore
			local ore = {}
			--fill with white sound
			for x = 1,25 do
				for y = 1,25 do
					chunk.setPoint(x,y,random.range(0,100,x+id.X*25,y+id.Y*25,index)/100,ore)
				end
			end
			--blur the sound
			for xIndex,xValue in pairs(ore) do
				for yIndex,v in pairs(xValue) do
					chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
					chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
					chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
					chunk.gaussian(ore,Vector2.new(xIndex,yIndex),blurTable)
				end
			end
			--step sound
			ore = chunk.filterStep(ore,oreValue.func,oreIndex)
			--apply sound to chunk allowing oreIndex
			chunkOres = chunk.applyOre(chunkOres,ore,oreIndex)
		end
	end
	chunk.data[id.X][id.Y] = chunkOres
end

function chunk.checkChunk(x,y,ox,oy)
	local chunkX = math.floor(x/25)+ox
	local chunkY = math.floor(y/25)+oy
	--local posX = x%25+1
	--local posY = y%25+1

	if chunk.data[chunkX] == nil or chunk.data[chunkX][chunkY] == nil then
		if not chunkThread:isRunning() then
			print('Creating chunk:' .. chunkX .. ':' .. chunkY)
			chat.addItem('Creating chunk:' .. chunkX .. ':' .. chunkY)

			chunkChannelRequest:push(chunkX)
			chunkChannelRequest:push(chunkY)
			chunkThread:start()

			if not chunk.data[chunkX] then chunk.data[chunkX] = {} end
			chunk.data[chunkX][chunkY] = true
		else
			chunk.queue[#chunk.queue+1] = Vector2.new(chunkX,chunkY)
		end
	end
end

function chunk.checkQueue()
	if not chunkThread:isRunning() and #chunk.queue > 0 then
		local chunks = chunk.queue[1]
		local chunkX,chunkY = chunks.X,chunks.Y
		table.remove(chunk.queue,1)

		print('Creating chunk:' .. chunkX .. ':' .. chunkY)
		chat.addItem('Creating chunk:' .. chunkX .. ':' .. chunkY)

		chunkChannelRequest:push(chunkX)
		chunkChannelRequest:push(chunkY)
		chunkThread:start()

		if not chunk.data[chunkX] then chunk.data[chunkX] = {} end
		chunk.data[chunkX][chunkY] = true
	end
end

function chunk.loadThread()
	if chunkChannelReturn:getCount() >= 3 then
		--print('Stack size is:' .. chunkChannelReturn:getCount())
		local x = chunkChannelReturn:pop()
		--print('X value is: ' .. x)
		local y = chunkChannelReturn:pop()
		--print('Y value is: ' .. y)
		local value = chunkChannelReturn:pop()
		--print('Value is: ' .. value)
		if map:getBackground()[x] == nil or map:getBackground()[x][y] == nil then
			map:setPoint(x,y,value,true)
			map:backgroundSetPoint(x,y,value)
		else
			chunk.loadThread()
		end
	end
end

function chunk.loadChunk()
	chunk.checkQueue()
	for i = 1,8 do
		chunk.loadThread()
	end
end

		--chunk.createChunk(Vector2.new(chunkX,chunkY),data.ores)
		--[[local chunk = chunk.data[chunkX][chunkY]
		for x = 1,25 do
			for y = 1,25 do
				if map.map[chunkX*25+x] == nil or map.map[chunkX*25+x][chunkY*25+y] == nil then
					map:setPoint(chunkX*25+x,chunkY*25+y,chunk[x][y])
					map:backgroundSetPoint(chunkX*25+x,chunkY*25+y,chunk[x][y])
				end
			end
		end]]

--[[function chunk.getMapPosition(pos)
	local chunkX = pos.X/25-pos.X%25/25
	local chunkY = pos.Y/25-pos.Y%25/25
	local posX = pos.X%25+1
	local posY = pos.Y%25+1
	if chunk.data[chunkX] == nil or chunk.data[chunkX][chunkY] == nil then
		print('Calling to create chunk: ' .. chunkX .. ':' .. chunkY)
		chunk.createChunk(Vector2.new(chunkX,chunkY),data.ores)
	end
	--print('Accessing block: ' .. chunkX .. ':' .. chunkY .. '    ' .. posX .. ':' .. posY)
	--print('Chunk: ' .. tostring(chunk.data[chunkX][chunkY]))
	--print('Sub block ' .. tostring(chunk.data[chunkX][chunkY][posX]))
	local chunk = chunk.data[chunkX][chunkY]
	for x = 1,25 do
		for y = 1,25 do
			if map.map[chunkX+x][chunkY+y] == nil then
				map:setPoint(chunkX+x,chunkY+y,chunk[x][y])
				map:backgroundSetPoint(chunkX+x,chunkY+y,chunk[x][y])
			end
		end
	end
end]]