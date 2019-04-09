-----------------
--buttons
-----------------

buttons = {}

buttons.list = {}
buttons.indexedList = {}
buttons.validzIndexes = {1,2,3,4,5,6,7,8,9} -- only use these for zIndexs if you want the button to be drawn

--{pos,size,image or draw,zIndex,clicked,active} -- higher Z = on top of other elements

function buttons.addButton(button,id)
	button.id = id
	if buttons.list[id] == nil then

		if not buttons.indexedList[button.zIndex] then
			buttons.indexedList[button.zIndex] = {}
		end

		buttons.indexedList[button.zIndex][id] = button
		buttons.list[id] = button

	else
		print("Error, tried to add button with the same ID",id)
	end
end

function buttons.removeButton(id)
	if buttons.list[id] then
		buttons.indexedList[buttons.list[id].zIndex][id] = nil
		buttons.list[id] = nil
	else
		print("Error, tried to remove button with the ID",id)
	end
end

function buttons.moveButton(id,pos)
	if buttons.list[id] then
		buttons.list[id].pos = pos
		buttons.indexedList[buttons.list[id].zIndex][id].pos = pos
	else
		print("Error, tried to move button with the ID",id)
	end
end

function buttons.activeButton(id,value)
	if buttons.list[id] then
		buttons.list[id].active = value
	else
		print('Error, tried to set activity of button with the Id: ' .. id)
	end
end

function buttons.changeImage(id,image)
	if buttons.list[id] then
		buttons.list[id].image = image
		buttons.indexedList[buttons.list[id].zIndex][id].image = image
	else
		print("Error, tried to change image for button with the ID",id)
	end
end

function buttons.checkForButton(id)
	return not (buttons.list[id] == nil)
end

function buttons.checkHover(id)
	local pos = mouse
	v = buttons.list[id]
	if pos.X >= v.pos.X and pos.Y >= v.pos.Y then
		if pos.X <= v.pos.X+v.size.X and pos.Y <= v.pos.Y+v.size.Y then
			return true
		end
	end
	return false
end

function buttons.checkButtons(pos)
	buttonClickedId = nil
	buttonClickedZ = -999
	for i,v in pairs(buttons.list) do
		if pos.X >= v.pos.X and pos.Y >= v.pos.Y then
			if pos.X <= v.pos.X+v.size.X and pos.Y <= v.pos.Y+v.size.Y then
				if v.zIndex > buttonClickedZ and (v.active == nil or v.active == true) then
					buttonClickedZ = v.zIndex
					buttonClickedId = v.id
				end
			end
		end
	end
	if buttonClickedId then
		print(buttonClickedId)
		buttons.list[buttonClickedId].clicked(buttonClickedId)
	end
end

function buttons.drawButtons()
	for i,v in ipairs(buttons.validzIndexes) do
		if buttons.indexedList[v] then
			for i,v in pairs(buttons.indexedList[v]) do
				if v.image then
					love.graphics.setColor(0,0,0,50)
					love.graphics.draw(v.image,v.pos.X+4,v.pos.Y+4)
					love.graphics.setColor(255,255,255)
					if v.active == nil or v.active == true then
						if not buttons.checkHover(v.id) then
							love.graphics.draw(v.image,v.pos.X,v.pos.Y)
						else
							if love.mouse.isDown('l') then
								love.graphics.draw(v.image,v.pos.X+3,v.pos.Y+3)
							else
								love.graphics.draw(v.image,v.pos.X+2,v.pos.Y+2)
							end
						end
					else
						love.graphics.setColor(127,127,127)
						love.graphics.draw(v.image,v.pos.X+4,v.pos.Y+4)
					end
				elseif v.draw then
					v.draw()
				end
			end
		end
	end
	love.graphics.setColor(255,255,255)
end
