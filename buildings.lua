----------------
---buildings
----------------
--Old system for interface of buildings
--timer, drawing, interface
----------------

buildings = {}
buildings.buttons = {}

function buildings.init()
	buildings.show = {}
	buildings.buttons.list = {}
	buildings.building = {'BlackSmith','ToolsShop','Market'}
end

function buildings.buttons.addButton(pos,size,identifier)
	buildings.buttons.list[#buildings.buttons.list+1] = {position = pos,size = size,id = identifier}
end

function buildings.buttons.resetButtons()
	buildings.buttons.list = {}
end

function buildings.buttons.removeButton(id)
	for i,v in pairs(buildings.buttons.list) do
		if v.id == id then
			table.remove(buildings.buttons.list,i)
		end
	end
end

function buildings.buttons.checkButtons(mouse)
	for i,v in pairs(buildings.buttons.list) do
		if mouse.X >= v.position.X and mouse.X <= v.position.X+v.size.X then
			if mouse.Y >= v.position.Y and mouse.Y <= v.position.Y+v.size.Y then
				return v.id
			end
		end
	end
end

function buildings.checkBuilding(building)
	--[[local value = false
	local remove = 0
	for i,v in pairs(buildings.buildings) do
		if v.building == building then
			if value == false then
				value = true
			else
				remove = i
			end
		end
	end
	if remove ~= 0 then
		table.remove(buildings.buildings,remove)
	end
	return value]]
end

function buildings.draw()
	--[[
	love.graphics.setColor(255,255,255)
	for i,v in pairs(buildings.buildings) do
		for i,v in pairs(blockIndexing.getBlock(v)) do
			if v.start+v.buildTime > os.time() then
				love.graphics.print('Constructing ' .. v.start+v.buildTime-os.time(),positions[v.building]+Camera.X+103,150+Camera.Y)
				love.graphics.draw(images[v.building .. 'Construct'],positions[v.building]+Camera.X,150+Camera.Y,nil,1.5,1.5)
			else
				buildings.buildings[i].done = true
			love.graphics.draw(images[v.building],positions[v.building]+Camera.X,150+Camera.Y,nil,1.5,1.5)
			end
		end
	end]]
end

function buildings.run()
	--print('Buildings running')
	--print('Buildings are:',table.concat(buildings.building,', '))
	for i,name in pairs(buildings.building) do
		--print('Calling blockIndexing')
		for i,pos in pairs(blockIndexing.getBlock(name)) do
			--print('Building:',name,'Is at:',pos*100+Vector2.new(100,575),'Camera:',Camera*-1+Vector2.new(screenSize.X/2,375))
			if magnitude((Camera*-1+Vector2.new(screenSize.X/2,375))-(pos*100+Vector2.new(100,575))) < 150 then
				if buildings.show[name] then
					buildings[name].draw()
				else
					love.graphics.print('Press q to access the ' .. name,screenSize.X/2-100,screenSize.Y-200)
				end
			else
				buildings.show[name] = false
			end
		end
	end
end

function buildings.mouseButton(pos)
	for i,v in pairs(buildings.show) do
		if v then
			local id = buildings.buttons.checkButtons(pos)
			if id then
				buildings[i].buttonDown(id)
			end
		end
	end
end

function buildings.keyPressed(key)
	for i,name in pairs(buildings.building) do
		for i,pos in pairs(blockIndexing[name]) do
			if magnitude((Camera*-1+Vector2.new(screenSize.X/2,375))-(pos*100+Vector2.new(100,575))) < 150 then
				local key = key:lower()
				if key == 'q' then
					buildings.show[name] = not buildings.show[name]
				end
			end
			if key == 'escape' then
				buildings.show[name] = false
			end
		end
	end
end

buildings.Market= {}
buildings.Market.mode = 'Buying'

function buildings.Market.getItems()
	local list = {}
	for i,v in pairs(data.buyableBlocks) do
		list[i] = data.itemInfo[v]
		list[i].block = v
	end
	return list
end

function buildings.Market.draw()
	buildings.buttons.resetButtons()
	love.graphics.draw(images.ShopMenu,screenSize.X/2-400,60)
	love.graphics.print('Mode: ' .. buildings.Market.mode,screenSize.X/2-80,200)
	buildings.buttons.addButton(Vector2.new(screenSize.X/2-80,200),Vector2.new(120,23),'changemode')
	if buildings.Market.mode == 'Buying' then
		for i,v in pairs(buildings.Market.getItems()) do
			love.graphics.print(v.block,screenSize.X/2-400+10,200+i*25)
			love.graphics.print('Cost: ' .. v.value*2,screenSize.X/2-400+400,200+i*25)
			love.graphics.line(screenSize.X/2-400+10,200+i*25+20,screenSize.X/2-400+790,200+i*25+20)
			love.graphics.print('Buy 10',screenSize.X/2-400+600,200+i*25)
			love.graphics.print('Buy 1',screenSize.X/2-400+700,200+i*25)
			buildings.buttons.addButton(Vector2.new(screenSize.X/2-400+700,200+i*25),Vector2.new(50,23),{block = v.block, mode = 'buy',cost = v.value*2})
			buildings.buttons.addButton(Vector2.new(screenSize.X/2-400+600,200+i*25),Vector2.new(50,23),{block = v.block, mode = 'bbuy',cost = v.value*2*10})
		end
	else
		for i,v in pairs(backpack.items) do
			love.graphics.print(v.block,screenSize.X/2-400+10,200+i*25)
			love.graphics.print(v.amount,screenSize.X/2-400+100,200+i*25)
			local value = math.floor(data.itemInfo[v.block].value*5/3)
			love.graphics.print('Value: ' .. value,screenSize.X/2-400+200,200+i*25)
			love.graphics.line(screenSize.X/2-400+10,200+i*25+20,screenSize.X/2+400-10,200+i*25+20)
			love.graphics.print('Sell 1',screenSize.X/2-400+600,200+i*25)
			love.graphics.print('Sell All',screenSize.X/2-400+700,200+i*25)
			--id format = {index = i,mode = sellall/sell1}
			buildings.buttons.addButton(Vector2.new(screenSize.X/2-400+600,200+i*25),Vector2.new(50,23),{index = i,mode = 'single',cost = value})
			buildings.buttons.addButton(Vector2.new(screenSize.X/2-400+700,200+i*25),Vector2.new(50,23),{index = i, mode = 'all',cost = value})
		end
	end
end

function buildings.Market.buttonDown(id)
	if id == 'changemode' then
		if buildings.Market.mode == 'Buying' then
			buildings.Market.mode = 'Selling'
		else
			buildings.Market.mode = 'Buying'
		end
	elseif id.mode == 'buy' then
		if stats.money >= id.cost then
			stats.money = stats.money - id.cost
			backpack.addItem(id.block)
		end
	elseif id.mode == 'bbuy' then
		if stats.money >= id.cost then
			stats.money = stats.money - id.cost
			for i = 1,10 do
				backpack.addItem(id.block)
			end
		end
	elseif id.mode == 'single' then
		backpack.items[id.index].amount = backpack.items[id.index].amount-1
		stats.addMoney(id.cost)
		if backpack.items[id.index].amount <= 0 then
			table.remove(backpack.items,id.index)
			townhall.buttons.removeButton(id)
		end
	elseif id.mode == 'all' then
		stats.addMoney(id.cost*backpack.items[id.index].amount)
		table.remove(backpack.items,id.index)
		townhall.buttons.removeButton(id)
	end
end

buildings.BlackSmith = {}

function buildings.BlackSmith.getItems()
	local list = {}
	for i,v in pairs(stats.ownedItems) do
		if v.name ~= 'hand' then
			list[#list+1] = v
		end
	end
	return list
end

function buildings.BlackSmith.draw()
	love.graphics.draw(images.BlackSmithMenu,screenSize.X/2-400,60)
	love.graphics.print('Mode: Upgrading',screenSize.X/2-80,200)
	buildings.buttons.resetButtons()
	for i,v in pairs(buildings.BlackSmith.getItems()) do
		love.graphics.print(v.name,screenSize.X/2-400+10,200+i*25)
		love.graphics.print('Current Level: ' .. data.toolLevels[v.toolLevel].name,screenSize.X/2-400+100,200+i*25)
		if v.toolLevel < 6 then
			love.graphics.print('Upgrade Cost: ' .. data.toolLevels[v.toolLevel+1].cost(v.cost),screenSize.X/2-400+400,200+i*25)
			buildings.buttons.addButton(Vector2.new(screenSize.X/2-400+700,200+i*25),Vector2.new(50,23),{index = v.index, mode = 'upgrade',cost = data.toolLevels[v.toolLevel+1].cost(v.cost)})
		else
			love.graphics.print('Max Level',screenSize.X/2-400+400,200+i*25)
		end
		love.graphics.line(screenSize.X/2-400+10,200+i*25+20,screenSize.X/2-400+790,200+i*25+20)
		love.graphics.print('Upgrade',screenSize.X/2-400+700,200+i*25)
	end
end

function buildings.BlackSmith.buttonDown(id)
	if id.mode == 'upgrade' then
		if stats.money >= id.cost then
			stats.money = stats.money - id.cost
			stats.ownedItems[id.index].toolLevel = stats.ownedItems[id.index].toolLevel+1
		end
	end
end

buildings.ToolsShop = {}

function buildings.ToolsShop.getItems()
	local items = {}
	for i,v in pairs(data.tools) do
		local isOwned = false
		for c,b in pairs(stats.ownedItems) do
			if b.name == v.name then
				isOwned = true
			end
		end
		if not isOwned then
			items[#items+1] = v
		end
	end
	return items
end

function buildings.ToolsShop.draw()
	love.graphics.draw(images.ToolsShopMenu,screenSize.X/2-400,60)
	love.graphics.print('Mode: Buying',screenSize.X/2-80,200)
	buildings.buttons.resetButtons()
	for i,v in pairs(buildings.ToolsShop.getItems()) do
		love.graphics.print(v.name,screenSize.X/2-400+10,200+i*25)
		--love.graphics.print(v.amount,300,200+i*25)
		love.graphics.print('Value: ' .. v.cost,screenSize.X/2-400+200,200+i*25)
		love.graphics.line(screenSize.X/2-400+10,200+i*25+20,screenSize.X/2-400+790,200+i*25+20)
		love.graphics.print('Buy',screenSize.X/2-400+700,200+i*25)
		--id format = {index = i,mode = sellall/sell1}
		buildings.buttons.addButton(Vector2.new(screenSize.X/2-400+700,200+i*25),Vector2.new(50,23),{index = v.index, mode = 'buy'})
	end
end

function buildings.ToolsShop.buttonDown(id)
	if id.mode == 'buy' then
		if stats.money >= data.tools[id.index].cost then
			stats.money = stats.money - data.tools[id.index].cost
			stats.ownedItems[#stats.ownedItems+1] = data.tools[id.index]
		end
	end
end

