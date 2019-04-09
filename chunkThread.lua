----------------
---chunk generation
----------------

require 'Vector2'
require 'data'
require 'random'

random.setSeed(77)

chunkChannelRequest = love.thread.getChannel('chunkRequest')
chunkChannelReturn = love.thread.getChannel('chunkReturn')

chunk = {}
chunk.data = {}--chunks are 25x25

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

local chunkX = chunkChannelRequest:pop()
local chunkY = chunkChannelRequest:pop()

chunk.createChunk(Vector2.new(chunkX,chunkY),data.ores)

print('Done creating chunk')

local chunk = chunk.data[chunkX][chunkY]
for x = 1,25 do
	for y = 1,25 do
		chunkChannelReturn:push(chunkX*25+x)
		chunkChannelReturn:push(chunkY*25+y)
		chunkChannelReturn:push(chunk[x][y])
	end
end