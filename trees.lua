--------------
---creates the trees in techminer
--------------

trees = {}

--5x7
--[[trees.pattern = {{'Leaves' , 'Wood'   , 'Leaves' ,'Wood'   , 'Leaves' };
				{'Leaves'  , 'Leaves' , 'Wood'   ,'Leaves' , 'Wood'   };
				{'Wood'    , 'Leaves' , 'Wood'   ,'Wood'   , 'Wood'   };
				{'air'     , 'Wood'   , 'Wood'   ,'Leaves' , 'Leaves' };
				{'air'     , 'Leaves' , 'Wood'   ,'Leaves' , 'air'    };
				{'air'     , 'air'    , 'Wood'   ,'air'    , 'air'    };
				{'air'     , 'air'    , 'Wood'   ,'air'    , 'air'    }}]]
				
trees.pattern = {{'air'    , 'Leaves' , 'Leaves' ,'Leaves' , 'air'    };
				{'Leaves'  , 'Leaves' , 'Leaves' ,'Leaves' , 'Leaves' };
				{'Leaves'  , 'Leaves' , 'Wood'   ,'Leaves' , 'Leaves' };
				{'Leaves'  , 'Leaves' , 'Wood'   ,'Leaves' , 'Leaves' };
				{'air'     , 'air'    , 'Wood'   ,'air'    , 'air'    };
				{'air'     , 'air'    , 'Wood'   ,'air'    , 'air'    };
				{'air'     , 'air'    , 'Wood'   ,'air'    , 'air'    }}


trees.offset = Vector2.new(3,7)
function trees.init()
	--stuff
end

function trees.getPoint(x)
	local map = map:getMap()
	for i = 0,-20,-1 do
		--print('Scanning',x,'At y',i,map[x][i])
		if map[x][i] == nil then
			return i
		end
	end
end

function trees.createArea(xMin,xMax)
	density = .1
	local list = {}
	for i = xMin,xMax do
		if random.range(0,1000,i,15,27)/1000 < density then
			list[i] = trees.getPoint(i)
		end
	end
	for i,v in pairs(list) do
		trees.createTree(Vector2.new(i,v))
	end
end

function trees.createTree(pos)
	local mapObj = map
	local map = map:getMap()
	pos = pos-trees.offset
	for yIndex,xValue in pairs(trees.pattern) do
		for xIndex,yValue in pairs(xValue) do
			if map[xIndex+pos.X] == nil then
				map[xIndex+pos.X] = {}
			end
			if map[xIndex+pos.X][yIndex+pos.Y] == nil or map[xIndex+pos.X][yIndex+pos.Y] == 'air' then
				mapObj:setPoint(xIndex+pos.X,yIndex+pos.Y,yValue)
				--map[xIndex+pos.X][yIndex+pos.Y] = yValue
			end
		end
	end
end

--height = 4,8
--split chance = 1/4
--length = 2-4
--split chance end = 1/4
--[[function trees.createTree(pos)
	local height = math.random(5,8)
	for i = -1,-height,-1 do
		map[pos.X][pos.Y+i] = 'Wood'
		if i <= -4 then
			local chance = math.random(0,100)/100
			if chance < 1 then--1/4 then
				--vec = unit(Vector2.new(math.random(-10,10),-5))
				trees.createBranch(pos+Vector2.new(0,i))
			end
		end
	end
end

function trees.createBranch(pos)
	print('Called branch at: ' .. tostring(pos))
	for i = 0,2,1 do--length do
		local newPos = pos+Vector2.new(i,0)
		if map[newPos.X] then
			print('Creating Wood Block at: ' .. tostring(newPos))
			map[newPos.X][newPos.Y] = 'Wood'
		end
	end
	for i = 1,length do
		local newPos = pos+vec*length
		local x,y = math.floor(newPos.X),math.floor(newPos.Y)
		if map[x] then
			map[x][y] = 'Wood'
		end
	end
end]]--