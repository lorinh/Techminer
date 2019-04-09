-----------
--Text boxes
----------
--Simple service for text boxes

textBox = {}

textBox.list = {}
--format: {pos,size,text,font,borderSize}
textBox.selected = nil
textBox.counter = 0

function textBox.addTextBox(info,id)
	if not textBox.list[id] then
		if not info.text then
			info.text = ""
		end
		textBox.list[id] = info
	else
		print('Trying to add a text box twice called: ' .. id)
	end
end

function textBox.removeTextBox(id)
	if textBox.list[id] then
		textBox.list[id] = nil
	else
		print('Trying to remove text box that doesnt exist called: ' .. id)
	end
end

function textBox.getText(id)
	if textBox.list[id] then
		return textBox.list[id].text
	else
		print("Error: Couldn't find textbox with the name: " .. id)
	end
end

function textBox.checkForTextBox(id)
	return not (textBox.list[id] == nil)
end

function textBox.mouseButtonUp(pos)
	textBox.selected = nil
	for i,v in pairs(textBox.list) do
		if v.pos.X < pos.X and v.pos.Y < pos.Y then
			if v.pos.X+v.pos.X > pos.X and v.pos.Y+v.pos.Y > pos.Y then
				textBox.selected = i
				print('Selected text box')
			end
		end
	end
end

function textBox.keyPressed(key)
	if textBox.selected then
		local info = textBox.list[textBox.selected]
		if key == 'backspace' and #info.text > 0 then
			info.text = string.sub(info.text,1,#info.text-1)
		else
			if keys.lshift or keys.rshift then
				key = string.upper(key)
			end
			if #key == 1 then
				info.text = info.text..key
			end
		end
		textBox.list[textBox.selected] = info
	end
end

function textBox.cursor()
	textBox.counter = textBox.counter%50+1
	if textBox.counter<25 then
		return '|'
	else
		return ' '
	end
end


function textBox.drawTextBoxes()
	love.graphics.setColor(255,255,255)
	for i,v in pairs(textBox.list) do
		love.graphics.setLineWidth(v.borderSize)
		love.graphics.setColor(0,0,0,50)
		love.graphics.rectangle('line',v.pos.X+4,v.pos.Y+4,v.size.X,v.size.Y)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('line',v.pos.X,v.pos.Y,v.size.X,v.size.Y)
		love.graphics.setFont(v.font)
		if textBox.selected == i then
			love.graphics.print(v.text .. (textBox.cursor()),v.pos.X+4,v.pos.Y+4)
		else
			love.graphics.print(v.text,v.pos.X+4,v.pos.Y+4)
		end
	end
end