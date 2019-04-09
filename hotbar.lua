----------------
---hotbar, unused
----------------

hotbar = {}
hotbar.buttons = {}
hotbar.buttons.list = {}

function hotbar.init()
	hotbar.mode = 'mine' 
	hotbar.selected = nil
	-------------------
	hotbar.toolBar = {}
	hotbar.toolBar.offset = 0
	hotbar.toolBar.velocity = 0
	
	hotbar.toolBar.mouseStart = 0
	hotbar.toolBar.mouseLast = 0
	
	hotbar.toolBar.move = false
	
	hotbar.toolBar.timeLast = 0
	hotbar.toolBar.getVel = false
end

function hotbar.buttons.addButton(pos,size,identifier)
	hotbar.buttons.list[#hotbar.buttons.list+1] = {position = pos,size = size,id = identifier}
end

function hotbar.buttons.resetButtons()
	hotbar.buttons.list = {}
end

function hotbar.buttons.removeButton(id)
	for i,v in pairs(hotbar.buttons.list) do
		if v.id == id then
			table.remove(hotbar.buttons.list,i)
		end
	end
end

function hotbar.buttons.checkButtons(mouse)
	for i,v in pairs(hotbar.buttons.list) do
		if mouse.X >= v.position.X and mouse.X <= v.position.X+v.size.X then
			if mouse.Y >= v.position.Y and mouse.Y <= v.position.Y+v.size.Y then
				return v.id
			end
		end
	end
end

function hotbar.mouseButton(mouse)
	local id = hotbar.buttons.checkButtons(mouse)
	if id then
		hotbar.mode = id
		if id == 'build' then
			hotbar.toolBar.offset = 0--stats.item*-75
		end
	end
	if magnitude(mouse-Vector2.new(screenSize.X/2,screenSize.Y-75)) < 150 then
		hotbar.toolBar.mouseStart = mouse.X
		hotbar.toolBar.mouseLast = mouse.X
		hotbar.toolBar.move = true
	else
		hotbar.toolBar.move = false
	end
end

function hotbar.mouseReleased()
	if hotbar.toolBar.move then
		hotbar.toolBar.offset = hotbar.toolBar.offset+(mouse.X-hotbar.toolBar.mouseStart)
		hotbar.toolBar.getVel = true
		hotbar.toolBar.mouseStart = 0
	end
end

function hotbar.keyPressed(key)
	if key == '1' then
		hotbar.mode = 'mine'
	elseif key == '2' then
		hotbar.mode = 'build'
	end
end

function hotbar.draw()
	--[[hotbar.buttons.resetButtons()
	if not backpack.show and not config.showMenu then
		love.graphics.setColor(255,255,255)
		if hotbar.mode == 'mine' then
			love.graphics.draw(images.iconSelect,screenSize.X/2-55,screenSize.Y-60,0,2/3,2/3)
		elseif hotbar.mode == 'build' then
			love.graphics.draw(images.iconSelect,screenSize.X/2+5,screenSize.Y-60,0,2/3,2/3)
		end

		love.graphics.draw(images.mineIcon,screenSize.X/2-55,screenSize.Y-60,0,2/3,2/3)
		love.graphics.draw(images.buildIcon,screenSize.X/2+5,screenSize.Y-60,0,2/3,2/3)
		
		hotbar.buttons.addButton(Vector2.new(screenSize.X/2-55,screenSize.Y-60),Vector2.new(50,50),'mine')
		hotbar.buttons.addButton(Vector2.new(screenSize.X/2+5,screenSize.Y-60),Vector2.new(50,50),'build')
		
		if hotbar.mode == 'build' then
			hotbar.toolBar.velocity = hotbar.toolBar.velocity*.9
			if hotbar.toolBar.velocity < 5 and hotbar.toolBar.velocity > -5 then
				hotbar.toolBar.velocity = 0
			end
			hotbar.toolBar.offset = hotbar.toolBar.offset+hotbar.toolBar.velocity
			if hotbar.toolBar.getVel then
				local difm = mouse.X-hotbar.toolBar.mouseLast
				hotbar.toolBar.velocity = difm
				hotbar.toolBar.getVel = false
			end
			hotbar.toolBar.mouseLast = mouse.X
			hotbar.toolBar.timeLast = love.timer.getTime()
			
			for i,v in pairs(backpack.items) do
				local pos
				if love.mouse.isDown('l') and hotbar.toolBar.move then
					pos = hotbar.toolBar.offset+(mouse.X-hotbar.toolBar.mouseStart)+i*100
				else
					pos = hotbar.toolBar.offset+i*100
				end
				pos = pos-(defaultFont:getWidth(v.block)/2)
				local transparency = 1-(math.abs(pos)/100)
				if transparency > 0 then
					if pos < 36.5 and pos > -36.5 then
						hotbar.selected = i
						love.graphics.setColor(127,255,127)
					else
						love.graphics.setColor(255,255,255,transparency*255)
					end
					local pos = pos+(screenSize.X/2-25)
					love.graphics.print(v.block,pos,screenSize.Y-100)
					--love.graphics.draw(images[v.name],pos,screenSize.Y-50,nil,1,1)
				end
			end
			if hotbar.toolBar.offset < -#backpack.items*100+30 then
				hotbar.toolBar.offset = -#backpack.items*100+30
			elseif hotbar.toolBar.offset > -50 then
				hotbar.toolBar.offset = -50
			end
		end
	end]]
end