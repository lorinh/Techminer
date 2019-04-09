----------------
---generate terrain on a seperate thread
----------------

random = {}
random.seed = 77
random.P1 = 16807
random.P2 = 0
random.lastValue = 77
random.maxValue = 2147483647

function random.setSeed(num)
	random.seed = num
	random.lastValue = num
end

function random.range(num1,num2,p1,p2,level)
	level = level and level or 1
	local range = math.max(num1,num2)-math.min(num1,num2)
	random.P1 = math.abs(p1)--+level
	random.P2 = math.abs(p2)--+level
	random.lastValue = (random.maxValue%(random.P1+random.P2)*random.P1)*random.seed*level
	random.lastValue = (random.P1*random.lastValue+random.P2)%random.maxValue
	return (random.lastValue%range)+math.min(num1,num2)
end

terrainChannelRequest = love.thread.getChannel('terrainRequest')
terrainChannelReturn = love.thread.getChannel('terrainReturn')

local terrain = {}

function terrain.whiteLine(x1,x2)
	local whiteLine = {}
	for i = x1,x2 do
		local x = random.range(0,1000,i,5,1)/1000
		print('Value for whiteLine is: ' .. x)
		whiteLine[i] = x
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
	print('Function was called')
	local whiteLine = terrain.whiteLine(x1,x2)
	print('White line is: ' .. table.concat(whiteLine,','))
	local whiteLine = terrain.gaussian(whiteLine)
	for xPos,value in pairs(whiteLine) do
		local value = value*30-5
		local value = value-value%1
		for y = 5,-value,-1 do
			--print(y,value)
			if y == -value then
				terrainChannelReturn:push(xPos)
				terrainChannelReturn:push(y)
				terrainChannelReturn:push('Grass')
				--print('Pushed: ' .. xPos .. ' : ' .. y .. ' : ' .. 'Grass')
				--map:setPoint(xPos,y,'Grass')
				--map:backgroundSetPoint(xPos,y,'Dirt')
			else
				terrainChannelReturn:push(xPos)
				terrainChannelReturn:push(y)
				terrainChannelReturn:push('Dirt')
				--print('Pushed: ' .. xPos .. ' : ' .. y .. ' : ' .. 'Dirt')
				--map:setPoint(xPos,y,'Dirt')
				--map:backgroundSetPoint(xPos,y,'Dirt')
			end
		end
	end
	--trees.createArea(x1,x2)
end

local min = terrainChannelRequest:pop()
local max = terrainChannelRequest:pop()

--print('Running terrain for: ' .. min  .. ' : ' .. max)
terrain.generate(min,max,false)