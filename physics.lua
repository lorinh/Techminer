-------------
--physics
------------
--4th version of physics for Techminer
--relys on bump.lua

physics = {}

physics.objects = {}


function physics.init()
	bump = require 'bump'

	physics.world = bump.newWorld(50)

	physics.dict = {}

	physics.objects.player = {}
	physics.objects.player.velocity = Vector2.new(0,0)
	physics.objects.player.staticVelocity = Vector2.new(0,0)
	physics.objects.player.position = Vector2.new(0,0)

	physics.playerAdded = false
end


function physics.run(delta)
	local delta = delta * 50

	local newPlayerData = {}

	newPlayerData.velocity = physics.objects.player.velocity            -- carry prevouise velocity
								- Vector2.new(0,.5) * delta             -- apply gravity
								+ physics.objects.player.staticVelocity -- apply character movement

	newPlayerData.position = Camera + (newPlayerData.velocity * delta)                       -- inversed position
	newPlayerData.position = (newPlayerData.position * -1) + Vector2.new(screenSize.X/2+10,375) -- global position

	 -- add the player if not yet added, can use calculated position
	if not physics.playerAdded then
		physics.world:add('player',newPlayerData.position.X,newPlayerData.position.Y,30,75)
		physics.playerAdded = true
	end

	 -- get collisions
	local x, y, collisions, count = physics.world:move('player',newPlayerData.position.X,newPlayerData.position.Y)

	 -- if there was a collision, get surface normal
	if count > 0 then
		--loop through collisions
		for i,v in pairs(collisions) do
			local normal = collisions[i].normal

			if normal.x == -1 then -- left of character
				newPlayerData.velocity.X = 0
			elseif normal.x == 1 then -- right of character
				newPlayerData.velocity.X = 0
			elseif normal.y == 1 then -- top of character
				newPlayerData.velocity.Y = 0
			elseif normal.y == -1 then -- bottom of character
				characterMovement.jumpDB = 0
				newPlayerData.velocity.Y = 0
			end
		end
	end

	 -- reset static velocity
	if newPlayerData.velocity.X ~= 0 then
		newPlayerData.velocity = newPlayerData.velocity - physics.objects.player.staticVelocity
	end

	physics.objects.player.velocity = newPlayerData.velocity

	Camera = ( Vector2.new(x,y) - Vector2.new(screenSize.X/2+10,375) )*-1 -- turn global position to inversed
end
