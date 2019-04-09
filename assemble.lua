----------------
---assemble or crafting screen, when ever you access a town hall
----------------

assemble = {}

assemble.class = {
	backpack = function(block) return {isBackpack = true,block = block} end,
	result = function() return {isResult = true} end
}
assemble.buttons = {}


 function assemble.init(keepGrid)
	assemble.buttons.buttons = {}
	assemble.selected = nil
	if not keepGrid then
		assemble.grid = {}
	end
	assemble.tempBackpack = assemble.cloneBackpack(backpack.items)
	assemble.outPut = nil
end

 function assemble.checkRecipes()

	--check full recipes
	for result,res in pairs(data.fullRecipe) do
		local cancel = false
		for xIndex,xValue in pairs(assemble.grid) do
			for yIndex,block in pairs(xValue) do
				if res[xIndex+1][yIndex+1] ~= block then
					cancel = true
				end
				if cancel then break end
			end
		end
		if not cancel then
			return result
		end
	end

	print('Checking pattern recipes')

	--pattern recipes
	for result,res in pairs(data.patternRecipe) do-- y and x in recipes are reversed order
		print('Checking Recipe: ' .. result.block)
		local start = Vector2.new(0,0)
		local foundFirstBlock = false
		local cancel = false
		for xIndex,xValue in pairs(assemble.grid) do
			for yIndex,block in pairs(xValue) do
				if cancel then break end
				if foundFirstBlock == false then
					if block == res[1][1] then
						print('Found start at:',xIndex,yIndex)
						start = Vector2.new(xIndex-1,yIndex-1)
						foundFirstBlock = true
					elseif block ~= 'air' then
						print('Recipe not found since unexpected block found before start')
						cancel = true
					end
				else
					local x = xIndex-start.X
					local y = yIndex-start.Y
					if (res[y] ~= nil and block == res[y][x]) or ((res[y] == nil or res[y][x] == nil) and block == 'air') then
						--do nothing
					else
						print('Recipe not found since unexpected block found after start')
						print('Unexpected block is: ' .. block .. ' at ' .. xIndex .. ':' .. yIndex,'Expected: ' .. (res[y] and res[y][x] or 'No value in recipe'))
						cancel = true
					end
				end
			end
		end
		if not cancel and foundFirstBlock == true then
			return result
		end
	end
	return nil
end

 function assemble.cloneBackpack(tab)
	local clone = {}
	for i,v in pairs(tab) do
		if v.block ~= nil then
			clone[#clone+1] = {amount = v.amount,block = v.block}
		end
	end
	return clone
end

 function assemble.buttons.addButton(pos,size,id)--{pos,size,id}
	assemble.buttons.buttons[#assemble.buttons.buttons+1] = {pos = pos,size = size,id = id}
end

 function assemble.buttons.checkButtons(pos)
	for i,v in pairs(assemble.buttons.buttons) do
		if v.pos.X < pos.X and v.pos.X+v.size.X > pos.X then
			if v.pos.Y < pos.Y and v.pos.Y+v.size.Y > pos.Y then
				return v.id
			end
		end
	end
	return nil
end

 function assemble.addGridSlot(pos,value)
	--print('Called with' .. tostring(pos))
	if assemble.grid[pos.X] and assemble.grid[pos.X][pos.Y] then
		--print('Changing value to: ' .. value)
		local prev = assemble.grid[pos.X][pos.Y]
		assemble.grid[pos.X][pos.Y] = value--assemble.selected
		return true,prev
	end
	return false
end

 function assemble.getGridSlot(pos)
	if assemble.grid[pos.X] and assemble.grid[pos.X][pos.Y] then
		--print('Changing value to: ' .. value)
		return assemble.grid[pos.X][pos.Y]
	end
end

 function assemble.keyPressed(key)
	if key == 'escape' or key == 'q' then
		currentMode = 'main'
	end
end

function assemble.mouseButton(pos)
	pos = pos or mouse
	local id = assemble.buttons.checkButtons(pos)
	if id and id.isBackpack then
		--print('ID')
		if assemble.getItems(id.block) > 0 then
			assemble.selected = id.block
		end
	elseif id and id.isResult then
		local count = {}
		print('Output button pressed')
		if assemble.outPut ~= nil then
			for xIndex,xValue in pairs(assemble.grid) do
				for yIndex,yValue in pairs(xValue) do
					if yValue ~= 'air' then
						if not count[yValue] then
							count[yValue] = 1
						else
							count[yValue] = count[yValue] + 1
						end
						backpack.removeItem(yValue)
					end
				end
			end
			local enough = true
			for i,v in pairs(count) do
				if assemble.getItems(i) and assemble.getItems(i) < v then
					enough = false
				end
			end
			for i = 1,assemble.outPut.amount do
				backpack.addItem(assemble.outPut.block)
			end
			if enough then
				assemble.init(true)
			else
				assemble.init()
			end
		end
	else
		local xOffset = screenSize.X/2-150
		local yOffset = screenSize.Y/2-150
		local x = pos.X-xOffset
		local y = pos.Y-yOffset
		local x = x-x%50
		local y = y-y%50
		local exists, prev = assemble.addGridSlot(Vector2.new(x/50,y/50),assemble.selected)
		if exists then
			if prev ~= 'air' then
				assemble.addItem(prev)
			end
			if not assemble.removeItem(assemble.selected) then
				assemble.selected = nil
			end
		end
		assemble.outPut = assemble.checkRecipes()
	end
end

 function assemble.mouseButtonRight(pos)
	pos = pos or mouse
	local xOffset = screenSize.X/2-150
	local yOffset = screenSize.Y/2-150
	local x = pos.X-xOffset
	local y = pos.Y-yOffset
	local x = x-x%50
	local y = y-y%50
	--print(x/50,y/50)
	assemble.addItem(assemble.getGridSlot(Vector2.new(x/50,y/50)))
	if not assemble.addGridSlot(Vector2.new(x/50,y/50),'air') then
		assemble.selected = nil
	end
	assemble.outPut = assemble.checkRecipes()
end

 function assemble.draw()
	love.graphics.draw(images.Background,0,0,nil,screenSize.X/1200,screenSize.Y/920)
	love.graphics.draw(images.Backpack,0,0,nil,1,1)
	
	for i,v in pairs(assemble.tempBackpack) do--draw backpack items
		local i = i-1
		local x = i%2
		local y = (i-x)/2
		love.graphics.draw(images[v.block],x*100+10,y*60+10,nil,.5,.5)
		love.graphics.print('x' .. v.amount,x*100+70,y*60+41)
		assemble.buttons.addButton(Vector2.new(x*100+10,y*60+10),Vector2.new(50,50),assemble.class.backpack(v.block))
	end
	
	if assemble.selected then--draw the mouse icon
		love.graphics.draw(images[assemble.selected],mouse.X,mouse.Y,nil,.5,.5)
	end
	
	--draw the grid, and create table first frame
	local centerX = screenSize.X/2-150
	local centerY = screenSize.Y/2-150
	for x = 0,6 do
		love.graphics.rectangle('fill',x*50+centerX,centerY,1,300)
		if assemble.grid[x] == nil and x < 6 then
			assemble.grid[x] = {}
		end
	end
	for y = 0,6 do
		love.graphics.rectangle('fill',centerX,y*50+centerY,300,1)
		for x = 0,5 do
			if assemble.grid[x][y] == nil and y < 6 then
				assemble.grid[x][y] = 'air'
			end
		end
	end
	
	--draw the blocks
	for xIndex,xValue in pairs(assemble.grid) do
		for yIndex,yValue in pairs(xValue) do
			--print('Block at: ' .. xIndex .. ' ' .. yIndex .. ' is ' .. yValue)
			if yValue ~= 'air' then
				--print('Drawing')
				love.graphics.draw(images[yValue],xIndex*50+centerX,yIndex*50+centerY,nil,.5,.5)
			end
		end
	end
	
	--draw output grid
	love.graphics.rectangle('fill',screenSize.X-100,screenSize.Y/2-25,1,50)
	love.graphics.rectangle('fill',screenSize.X-50,screenSize.Y/2-25,1,50)
	love.graphics.rectangle('fill',screenSize.X-100,screenSize.Y/2-25,50,1)
	love.graphics.rectangle('fill',screenSize.X-100,screenSize.Y/2+25,50,1)
	
	if assemble.outPut then
		love.graphics.draw(images[assemble.outPut.block],screenSize.X-100,screenSize.Y/2-25,0,.5,.5)
		love.graphics.printf(assemble.outPut.amount,screenSize.X-100+46,screenSize.Y/2-25+30,0,'right')
		assemble.buttons.addButton(Vector2.new(screenSize.X-100,screenSize.Y/2-25),Vector2.new(50,50),assemble.class.result())
	end
end

-----------backpack

 function assemble.getItems(item)
	for i,v in pairs(assemble.tempBackpack) do
		if v.block == item then
			return v.amount 
		end
	end
end

 function assemble.addItem(item)
	for i,v in pairs(assemble.tempBackpack) do
		if v.block == item then
			v.amount = v.amount+1
		end
	end
end

 function assemble.removeItem(item)
	for i,v in pairs(assemble.tempBackpack) do
		if v.block == item then
			v.amount = v.amount-1
			if v.amount == 0 then
				return false
			end
		end
	end
	return true
end