----------------
---Character Movement
----------------
--moves the character
----------------




characterMovement = {}

function characterMovement.init()
	characterMovement.climbDb = false
	characterMovement.frame = 0
	characterMovement.toBlock = nil
	characterMovement.origanol = nil
	characterMovement.jumpDB = 0
end

function characterMovement.getPosition(position)
	local position = position
	local x = math.floor(position.X/100)
	local y = math.floor((position.Y-450)/100)
	return Vector2.new(x,y)
end

function characterMovement.run()
	if chat.typing then return end
	if characterMovement.climbDb then
		characterMovement.frame = characterMovement.frame+stats.getWalkSpeed(2)
		if characterMovement.frame > 150 then
			characterMovement.climbDb = false
			characterMovement.frame = 0
		elseif characterMovement.frame > 100 and characterMovement.toBlock == 'up' then
			characterMovement.climbDb = false
			characterMovement.frame = 0
		end
	end
	--if characterMovement.jumpDB > 0 then
		--characterMovement.jumpDB = characterMovement.jumpDB-1
	--end
	if keys[keyBindings.w] and backpack.show == false then
		if characterMovement.jumpDB == 0 then
			physics.objects.player.velocity = Vector2.new(0,12)
			characterMovement.jumpDB = 20
		end
		--[[if not characterMovement.climbDb then
			local block = characterMovement.getPosition(Camera*-1+Vector2.new(screenSize.X/2,375))
			if map[block.X] and map[block.X][block.Y] == 'air' then
				if map[block.X] and (map[block.X][block.Y-1] == 'air' or map[block.X][block.Y-1] == 'WoodenPad') or (block.Y < 1 and map[block.X][block.Y-1] == nil) then
					if (Camera*-1+Vector2.new(screenSize.X/2,375)).X-block.X*100 < 25 then
						if map[block.X-1] and (map[block.X-1][block.Y-1] == 'air' or map[block.X-1][block.Y-1] == 'WoddenPad') or (block.Y < 1 and map[block.X-1][block.Y-1] == nil) then
							if map[block.X-1] and map[block.X-1][block.Y] ~= 'air' then
								characterMovement.origanol = Camera
								characterMovement.toBlock = 'left'
								characterMovement.climbDb = true
							end
						end
					else
						if map[block.X+1] and (map[block.X+1][block.Y-1] == 'air' or map[block.X+1][block.Y-1] == 'WoddenPad') or (block.Y < 1 and map[block.X+1][block.Y-1] == nil) then
							if map[block.X+1] and map[block.X+1][block.Y] ~= 'air' then
								characterMovement.origanol = Camera
								characterMovement.toBlock = 'right'
								characterMovement.climbDb = true
							end
						end
					end
				elseif map[block.X] and map[block.X][block.Y-1] == 'WoodenPad' then
					--characterMovement.origanol = Camera
					--characterMovement.toBlock = 'up'
					--characterMovement.climbDb = true
				end
			elseif map[block.X] and map[block.X][block.Y] == 'WoodenPad' then
				print(map[block.X][block.Y-1])
				if map[block.X][block.Y-1] == 'air' or map[block.X][block.Y-1] == 'WoodenPad' or (block.Y < 1 and map[block.X][block.Y-1] == nil)then
					characterMovement.origanol = Camera
					characterMovement.toBlock = 'up'
					characterMovement.climbDb = true
				end
			end
		end]]
	elseif keys[keyBindings.s] then
		--do nothing
	end
	if config.showMenu ~= true then
		if keys[keyBindings.d] and backpack.show == false then
			physics.objects.player.staticVelocity = Vector2.new(stats.getWalkSpeed(-5),0)
		elseif keys[keyBindings.a] and backpack.show == false then
			physics.objects.player.staticVelocity = Vector2.new(stats.getWalkSpeed(5),0)
		else
			physics.objects.player.staticVelocity = Vector2.new(0,0)
		end
	end
end