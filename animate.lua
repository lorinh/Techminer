----------------
---animate functions to animate the main character
----------------

animate = {}
animate.player = {}

 function animate.init()
	animate.player.frame = 0
	animate.delayFrame = 0
	animate.miningFrame = 1
	animate.mining = false

	animate.showTool = false
end

animate.data = {
	positions = {
		{position = Vector2.new(24,43)},
		{position = Vector2.new(28,35)},
		{position = Vector2.new(34,34)},
		{position = Vector2.new(36,31)},
		{position = Vector2.new(34,34)},
		{position = Vector2.new(29,36)},
		--{position = Vector2.new(19,36)},
		--{position = Vector2.new(14,35)},
		--{position = Vector2.new(10,32)}
		{position = Vector2.new(29,36)},
		{position = Vector2.new(34,34)},
		{position = Vector2.new(36,31)},
	}
}

 function animate.player.climb()
	if characterMovement.climbDb then
		if characterMovement.toBlock == 'left' then
			if characterMovement.frame <= 100 then
				Camera = characterMovement.origanol+Vector2.new(0,characterMovement.frame)
			else
				Camera = characterMovement.origanol+Vector2.new(characterMovement.frame-100,100)
			end
		elseif characterMovement.toBlock == 'right' then
			if characterMovement.frame <= 100 then
				Camera = characterMovement.origanol+Vector2.new(0,characterMovement.frame)
			else
				Camera = characterMovement.origanol-Vector2.new(characterMovement.frame-100,-100)
			end
		elseif characterMovement.toBlock == 'up' then
			if characterMovement.frame <= 100 then
				Camera = characterMovement.origanol+Vector2.new(0,characterMovement.frame)
			end
		end
	end
end

 function animate.player.draw()
 	local tool = backpack:getTool()
	local itemInfo = data.itemInfo[tool]
	if characterMovement.climbDb then
		if characterMovement.toBlock == 'left' then
			love.graphics.draw(images.playerAnimation['Climb'..tostring(math.floor(characterMovement.frame/4)%11+1)],screenSize.X/2+50,375,nil,-1,1)
		elseif characterMovement.toBlock == 'right' then
			love.graphics.draw(images.playerAnimation['Climb'..tostring(math.floor(characterMovement.frame/4)%11+1)],screenSize.X/2,375,nil,1,1)
		elseif characterMovement.toBlock == 'up' then
			love.graphics.draw(images.playerAnimation['Climb'..tostring(math.floor(characterMovement.frame/4)%11+1)],screenSize.X/2,375,nil,1,1)
		end
	elseif (keys[keyBindings.d] or keys[keyBindings.a]) and config.showMenu ~= true then
		animate.delayFrame = (animate.delayFrame%4)+1
		if animate.delayFrame == 1 then
			animate.player.frame = animate.player.frame+1
			if animate.player.frame > 7 then
				animate.player.frame = 2
			end
			--animate.player.frame = (animate.player.frame % 6)+1
		end
		if keys[keyBindings.d] then
			love.graphics.draw(images.playerAnimation['Step'..tostring(animate.player.frame)],screenSize.X/2+25*(zoom-1),375,nil,1,1)
		elseif keys[keyBindings.a] then
			love.graphics.draw(images.playerAnimation['Step'..tostring(animate.player.frame)],screenSize.X/2+50+25*(zoom-1),375,nil,-1,1)
		end
	elseif animate.mining then
		animate.miningFrame = animate.miningFrame+itemInfo.rate
		if animate.miningFrame > itemInfo.frames then
			animate.miningFrame = 1
		end
		if mouse.X < screenSize.X/2 then
			love.graphics.draw(images.playerAnimation[itemInfo.name .. math.floor(animate.miningFrame)],screenSize.X/2+50+25*(zoom-1),375,nil,-1,1)
		else
			love.graphics.draw(images.playerAnimation[itemInfo.name .. math.floor(animate.miningFrame)],screenSize.X/2+25*(zoom-1),375,nil,1,1)
		end
	else
		if mouse.X < screenSize.X/2 then
			love.graphics.draw(images.playerAnimation['Standing'],screenSize.X/2+50+25*(zoom-1),375,nil,-1,1)
		else
			love.graphics.draw(images.playerAnimation['Standing'],screenSize.X/2+25*(zoom-1),375,nil,1,1)
		end
		animate.player.frame = 0
		animate.delayFrame = 0
		animate.miningFrame = 1
	end
end
