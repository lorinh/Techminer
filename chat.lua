---------------
--Chat and commands
---------------

chat = {}

chat.messages = {}
chat.typing = false
chat.text = ''
--format = {time = num,msg = str}

function chat.checkCommand(command)
	if string.sub(command,1,1) == '/' then
		if command == '/reset' then
			Camera = Vector2.new(0,400)--terrain.spawn
			physics.objects.player.velocity = Vector2.new(0,0)
			print(Camera)
		elseif string.sub(command,1,5) == '/give' then
			local item = string.sub(command,7,#command)
			if data.itemInfo[item] then
				backpack.addItem(item)
			end
		end
	end
end

function chat.addItem(text)
	table.insert(chat.messages,1,{text = text,time = os.time()})
end

function chat.keyPressed(key)
	--print(key)
	if key == 'escape' then
		chat.typing = false
	elseif key == 'backspace' then
		chat.text = string.sub(chat.text,1,#chat.text-1)
	elseif key == 'return' then
		if chat.typing then
			chat.checkCommand(chat.text)
			chat.addItem(chat.text)
			chat.text = ''
			chat.typing = false
		else
			chat.typing = true
		end
	elseif chat.typing == true and #key == 1 then
		if keys.lshift then
			chat.text = chat.text .. string.upper(key)
		else
			chat.text = chat.text .. key
		end
	elseif key == '/' then
		chat.typing = true
		chat.text = '/'
	end
end

function chat.draw()
	if chat.typing then
		love.graphics.setColor(0,0,0,127)
		love.graphics.rectangle('fill',10,screenSize.Y-20,200,20)
		love.graphics.setColor(255,255,255)
		love.graphics.print(chat.text,10,screenSize.Y-20)
	end
	for i,v in ipairs(chat.messages) do
		if os.time()-v.time < 15 then
			love.graphics.print(v.text,10,screenSize.Y-20-(i*22))
		elseif chat.typing then
			love.graphics.print(v.text,10,screenSize.Y-20-(i*22))
		end
	end
end