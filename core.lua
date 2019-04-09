----------------
---core functions
----------------
--Most core functions of the game, such as placing and removing blocks, and some for terrain generation
----------------

coreFunctions = {}
coreFunctions['local'] = {}

function coreFunctions.init()
	coreFunctions.physics = {}
	coreFunctions.physics.static = Vector2.new(0,0)
	coreFunctions.mine = {}
	coreFunctions.mine.block = nil
	coreFunctions.mine.frame = 0
	
	coreFunctions.mouseOrigin = nil
end

coreFunctions['local'].getLocalBlocks = function(pos,block)
	local check = 0
	for i,v in pairs({Vector2.new(1,0),Vector2.new(0,1),Vector2.new(-1,0),Vector2.new(0,-1)}) do
		if map[x] and map[x][y] == block then
			check = check+1
			check = check+coreFunctions['local'].getLocalBlocks(pos+v,block)
		end
	end
	return check
end

function coreFunctions.createChunk(x,y,ox,oy)
	if math.floor(y/25)+oy > -1 then
		chunk.checkChunk(x,y,ox,oy)
	end
end

--[[coreFunctions['local'].getSetMapPosition = function(x,y)
	local mapLibrary = map
	local map = map:getMap()
	if (map[x] ~= nil and map[x][y] ~= nil) or y < 0 then return end
	if y < 0 then
		mapLibrary:setPoint(x,y,'air')
	else
		chunk.getMapPosition(Vector2.new(x,y))
	end
end]]

function coreFunctions.checkAir(pos)
	local air = false
	local map = map:getMap()
	for i,v in pairs({Vector2.new(0,1),Vector2.new(0,-1),Vector2.new(-1,0),Vector2.new(1,0)}) do
		local pos = pos+v
		if map[pos.X] and map[pos.X][pos.Y] then
			if map[pos.X][pos.Y] == 'air' or data.itemInfo[map[pos.X][pos.Y]].solid == false then
				air = true
			end
		elseif not map[pos.X][pos.Y] then
			air = true
		end
	end
	return air
end

function coreFunctions.placeBlock()
	if not backpack.show and backpack.mode == 'build' and backpack.hotBar[backpack.selectedId].amount > 0 then
		local position = mouse+Camera*-1
		local x = math.floor(position.X/50)
		local y = math.floor((position.Y-450)/50)
		if coreFunctions.checkBlock(Vector2.new(x,y),backpack.hotBar[backpack.selectedId].block) then
			--map[x][y] = backpack.items[hotbar.selected].block
			map:setPoint(x,y,backpack.hotBar[backpack.selectedId].block)
			backpack.hotBar[backpack.selectedId].amount = backpack.hotBar[backpack.selectedId].amount - 1
			if backpack.hotBar[backpack.selectedId].amount <= 0 then
				backpack.hotBar[backpack.selectedId].block = nil
			end
			backpack.updateMode()
		end
	end
end

function coreFunctions.checkBlock(pos,block)
	local map = map:getMap()
	if not block then
		return false
	end
	block = data.itemInfo[block]
	--print(block)
	if block and not block.size then
		--print('No size')
		return map[pos.X] and (map[pos.X][pos.Y] == 'air' or (pos.Y < 0 and map[pos.X][pos.Y] == nil))
	elseif block then
		for x = 1,block.size.X do
			for y = 1,block.size.Y do
				local x = x - 1
				local y = y - 1
				local temp  = map[pos.X+x][pos.Y+y] == 'air' or (pos.Y < 0 and map[pos.X+x][pos.Y+y] == nil)
				if temp ~= true then
					return false
				end
			end
		end
		return true
	end
end

function coreFunctions.hoverBlock()
	if not backpack.show and backpack.mode == 'build' and backpack.hotBar[backpack.selectedId].amount > 0 then
		local position = mouse+Camera*-1
		local x = math.floor(position.X/50)
		local y = math.floor((position.Y-450)/50)
		local pos = Vector2.new(x*50+Camera.X,y*50+Camera.Y+450)
		local value = backpack.hotBar[backpack.selectedId].amount > 0 and backpack.hotBar[backpack.selectedId].block or nil
		if coreFunctions.checkBlock(Vector2.new(x,y),value) and value then
			love.graphics.setColor(0,255,0,127)
			love.graphics.draw(images[value],pos.X,pos.Y,0,.5 * (data.itemInfo[value].scale and data.itemInfo[value].scale or 1),.5 * (data.itemInfo[value].scale and data.itemInfo[value].scale or 1))
		elseif value then
			love.graphics.setColor(255,0,0,127)
			love.graphics.draw(images[value],pos.X,pos.Y,0,.5 * (data.itemInfo[value].scale and data.itemInfo[value].scale or 1),.5 * (data.itemInfo[value].scale and data.itemInfo[value].scale or 1))
		end	
	end
end

function coreFunctions.mouseReleased()
	coreFunctions.placeBlock()
	--[[if not backpack.show and backpack.mode == 'build' and magnitude(coreFunctions.mouseOrigin-mouse) < 5 then
		coreFunctions.placeBlock()
	end]]
end

function coreFunctions.mouseButton(mouse)
	coreFunctions.mouseOrigin = mouse
end

function coreFunctions.mineBlock()
	if love.mouse.isDown('l') and not backpack.show and backpack.mode == 'mine' then
		local map = map:getMap()
		local position = mouse+Camera*-1
		local x = math.floor(position.X/50)
		local y = math.floor((position.Y-450)/50)
		if coreFunctions.mine.block.X == x and coreFunctions.mine.block.Y == y then
			local block = map[x] and map[x][y]
			if map[x] and map[x][y] and string.sub(block,1,1) == '_' then
				block = string.sub(block,2,#block)
			end
			if map[x] and block and coreFunctions.checkAir(Vector2.new(x,y)) then
				local tool = backpack:getTool()
				local itemInfo = data.itemInfo[tool]
				if itemInfo.level >= data.itemInfo[block].level then
					coreFunctions.mine.frame = coreFunctions.mine.frame+
						150/(
							data.itemInfo[block].breakFrames*
							stats.getMineNum()*
							itemInfo.speed
							)
					animate.mining = true
					--print('Frame number:' .. coreFunctions.mine.frame)
					if coreFunctions.mine.frame >= 150 then
						coreFunctions.removeBlock(mouse)
						coreFunctions.mine.frame = 0
						backpack:removeDurability()
					end
				else
					animate.mining = false
				end
			else
				animate.mining = false
			end
		else
			coreFunctions.mine.block = Vector2.new(x,y)
			coreFunctions.mine.frame = 0
		end
	else
		coreFunctions.mine.block  = Vector2.new(0,0)
		coreFunctions.mine.frame = 0
		animate.mining = false
	end
end

--get top left block of multi-block blocks
function coreFunctions.getCoreOfMultiblock(X,Y)

	local map = map:getMap()

	local block = map[X][Y]
	local name = string.sub(block,2,#block)
	local blockData = data.itemInfo[name]

	for x = -blockData.size.X+1,blockData.size.X-1 do
		for y = -blockData.size.Y+1,blockData.size.Y-1 do
			if map[X+x][Y+y] == name then
				return X+x,Y+y
			end
		end
	end

	return nil
end

function coreFunctions.removeBlock(position)
	local mapObj = map
	local map = map:getMap()
	sounds.BlockBreak:play()

	local position = position+Camera*-1-Vector2.new(0,450)
	local X = (position.X-(position.X%50))/50
	local Y = (position.Y-(position.Y%50))/50

	local block = map[X][Y]

	if block ~= nil and block ~= 'air' then

		if string.sub(block,1,1) == '_' then
			X,Y = coreFunctions.getCoreOfMultiblock(x,y)
			block = map[X][Y]
			item = data.itemInfo[name].returns or name
		end

		item = data.itemInfo[block].returns or block
		if type(item) == 'table' then
			
		end

		backpack.addItem(item)

		stats.addBlockBroken()

		--remove block if you mine top left block
		if data.itemInfo[block] and data.itemInfo[block].size then
			local blockData = data.itemInfo[block]
			for x = 0,blockData.size.X-1 do
				for y = 0,blockData.size.Y-1 do
					if map[X+x][Y+y] == '_' .. block or map[X+x][Y+y] == block then
						mapObj:setPoint(X+x,Y+y,'air')
					end
				end
			end
		else
			mapObj:setPoint(X,Y,'air')
		end

		lastDugInChunk = math.floor(X/25) .. ':' .. math.floor(Y/25)

		coreFunctions.createChunk(X,Y,-1,0)
		coreFunctions.createChunk(X,Y,1,0)
		coreFunctions.createChunk(X,Y,0,-1)
		coreFunctions.createChunk(X,Y,0,1)
		coreFunctions.createChunk(X,Y,-1,-1)
		coreFunctions.createChunk(X,Y,-1,1)
		coreFunctions.createChunk(X,Y,1,-1)
		coreFunctions.createChunk(X,Y,1,1)

		coreFunctions.createChunk(X,Y,-2,0)
		coreFunctions.createChunk(X,Y,2,0)
		coreFunctions.createChunk(X,Y,0,-2)
		coreFunctions.createChunk(X,Y,0,2)
		coreFunctions.createChunk(X,Y,-2,-2)
		coreFunctions.createChunk(X,Y,-2,2)
		coreFunctions.createChunk(X,Y,2,-2)
		coreFunctions.createChunk(X,Y,2,2)

	end
end

