----------------
---physics
----------------
--notes
--uses map as hitboxes, each block being 50x50
--only tests 4 points of player(using localCamera+Vector2.new(0,450))
--vertexes of player are (20,0),(0,75),(0,0),(20,75)
----------------


--set limit to stop infinite loops
local MAXREPEAT = 3

--storage for this module
physics = {}

--all the moving objects in the game, contains only player
physics.objects = {}

--init function, called once to load this module
physics.init = function()
	
	--set up the player object
	physics.objects.player = {}
	physics.objects.player.velocity = Vector2.new(0,0)
	physics.objects.player.staticVelocity = Vector2.new(0,0)
	physics.objects.player.position = Vector2.new(0,0)
	
end

--checks aabb to aabb for any overlapping,(vector2 MovingObject,vector2 MovingObjectSize,bool group)
physics.getCollisions = function(position,size,group)
	--create a table to contain ever collision
	local collisions = {}
	
	--only check blocks on the screen for collisions( if true)
	if group then
		
		--calculate the x and y positions from camera to map
		local xStart = -(Camera.X-Camera.X%50)/50
		local yStart = -(Camera.Y-Camera.Y%50)/50
		
		--loop through all blocks of x and y on the screen
		for xIndex = xStart-1,xStart+25 do
			for yIndex = yStart-6,yStart+10 do
				
				--get type of block at value
				local value = map[xIndex] and map[xIndex][yIndex] or nil
				
				--if the value exists, and isn't air, isn't a specail block(Starts with '_') and should collide then
				if value and value ~= 'air' and not (value == 'WoodenPad' and keys.s == true) and string.sub(value,1,1) ~= '_' and data.itemInfo[value].physics ~= false then
					
					--get the screen local position of the block
					local blockPosition = Vector2.new(xIndex,yIndex)*50+Vector2.new(0,450)
					
					--loop through each vertex of the object called(Only player currently)
					for i,v in pairs({Vector2.new(0,size.Y),Vector2.new(size.X,0),Vector2.new(0,0),Vector2.new(size.X,size.Y)}) do
						--get vertex position
						local position = position+v
						
						--check aabb to aabb
						if position.X >= blockPosition.X and position.Y >= blockPosition.Y then
							if position.X <= blockPosition.X+50 and position.Y <= blockPosition.Y+50 then
								
								--if overlapping, add to collision table
								collisions[#collisions+1] = {position = blockPosition,vertex = v,block = value}
								
							end
						end
					end
				end
			end
		end
				
	else-- Otherwise check every block(Same coding, only loops through everything)
		for xIndex,xValue in pairs(map) do
			for yIndex,value in pairs(xValue) do
				if value ~= 'air' and not (value == 'WoodenPad' and keys.s == true) and string.sub(value,1,1) ~= '_' and data.itemInfo[value].physics ~= false then
					local blockPosition = Vector2.new(xIndex,yIndex)*50+Vector2.new(0,450)
					for i,v in pairs({Vector2.new(0,size.Y),Vector2.new(size.X,0),Vector2.new(0,0),Vector2.new(size.X,size.Y)}) do
						local position = position+v
						if position.X >= blockPosition.X and position.Y >= blockPosition.Y then
							if position.X <= blockPosition.X+50 and position.Y <= blockPosition.Y+50 then
								collisions[#collisions+1] = {position = blockPosition,vertex = v,block = value}
							end
						end
					end
				end
			end
		end
	end
	
	--return all of the collisions
	return collisions
end

--checks if a block should collide on a certain face or not(vector2 objectPosition, string face)
physics.checkSmoothSurface = function(object,face)
	
	--if face exists
	if face then
		normals = {left   =    Vector2.new(-1,0),
				   right  =    Vector2.new(1,0),
				   top    =    Vector2.new(0,-1),
				   bottom =    Vector2.new(0,1)}
			   
		--add face lookvector to position
		local x,y = object.X+normals[face].X, object.Y+normals[face].Y
		
		--if map position exists, return false
		if map[x] and map[x][y] ~= 'air' and map[x][y] ~= nil then
			return true
		end
	end
	
	--otherwise return true
	return true
end


--Where my problem is, (should) react to any collision given,(table collision[Has Vector2 blockPosition, Vector2 vertex, string type], table object[Has Vector2 position, Vector2 velocity], Vector2 lastPosition(Of object),vector2 size(of object), bool checkGround(For sliding over the map)
physics.reactToCollision = function(collision,object,lastPosition,size,checkGround)
	
	--get the last position based on the collided vertex
	local lastPosition = lastPosition+collision.vertex
	
	--get the slope of the velocity
	local slope = object.velocity.Y/object.velocity.X
	
	--get the b in the formula y=mx+b
	local offset = lastPosition.Y-(slope*lastPosition.X)
	
	------Top side
	if collision.vertex.Y == size.Y then
		
		--if slope is straight down then
		if tostring(slope) == '-inf' then

				--set y vel to 0, and move the object 75 pixels above the block
				local vel = Vector2.new(object.velocity.X,0)
				local pos = Vector2.new(object.position.X,collision.position.Y-75)
				return true,'top',vel,pos
				
			--check if the player is falling
		elseif object.velocity.Y < 0 then
			
			--convert y=mx+b to (y-b)/m=x or (-b+y)/m=x
			local x = (-offset+lastPosition.Y)/slope
			
			--check if collision is within the block's surface
			if x > collision.position.X and x < collision.position.X+50 then
				
				--set y vel to 0, and set the position to 75 pixels above the block
				local vel = Vector2.new(object.velocity.X,0)
				local pos = Vector2.new(object.position.X,collision.position.Y-75)
				return true,'top',vel,pos
			end
		end
	end
	
	--Bottom side of the woodenpad has only top physics, so explicidly defined here.
	if collision.block ~= 'WoodenPad' then
		
		------Bottom side
		--if vertex is a top vertex(Bottom vertex can't hit the top of blocks)
		if collision.vertex.Y == 0 then
			
			--Check if the slope is straight up
			if tostring(slope) == 'inf' then
				
				--set y vel to 0, and move the player 50 below the block
				local vel = Vector2.new(object.velocity.X,0)
				local pos = Vector2.new(object.position.X,collision.position.Y+50)
				return true,'bottom',vel,pos
				
			--if player y velocity is greater than 0
			elseif object.velocity.Y > 0 then
				--get the x point in the forumla y=mx+b, again being (y-b)/m=x or (-b+y)/m=x
				local x = (-offset+(lastPosition.Y+50))/slope
				
				--if the block is within bounds, then collide
				if x > collision.position.X and x < collision.position.X+50 then
					
					--set y vel to 0, and move the player 50 studs from the top of the block
					local vel = Vector2.new(object.velocity.X,0)
					local pos = Vector2.new(object.position.X,collision.position.Y+50)
					return true,'top',vel,pos
				end
			end
		end
		------Left side
		--if vertex is the right side, and simple ground drag bug fix
		if collision.vertex.X == size.X and (not checkGround and collision.vertex.Y == 0 or checkGround) then
			--if the slope is 0 then
			if slope == 0 then
				--set x vel to 0, and move the block 20 studs to the left of the block
				local vel = Vector2.new(0,object.velocity.Y)
				local pos = Vector2.new(collision.position.X-size.X,object.position.Y)
				return true,'left',vel,pos
			else
				--get the y position in the formula y = m*x+b
				local y = slope*lastPosition.X+offset
				--check if it is in bounds
				if y >= collision.position.Y and y <= collision.position.Y+50 then
					--set x vel to 0, and move the block 20 studs to the left of the block
					local vel = Vector2.new(0,object.velocity.Y)
					local pos = Vector2.new(collision.position.X-size.X,object.position.Y)
					return true,'left',vel,pos
				end
			end
		end
		------Right side
		--check if vertex is left side, and ground drag bug fix
		if collision.vertex.X == 0 and (not checkGround and collision.vertex.Y == 0 or checkGround) then
			--if the slope is 0 then
			if slope == 0 then
				--set the x vel to 0,and move the player 50 studs to the right of the  block
				local vel = Vector2.new(0,object.velocity.Y)
				local pos = Vector2.new(collision.position.X+50,object.position.Y)
				return true,'right',vel,pos
			else
				--get the y position in the formula y = m*x+b
				local y = slope*(lastPosition.X+50)+offset
				--check if it is in bounds
				if y >= collision.position.Y and y <= collision.position.Y+50 then
					--set the x vel to 0,and move the player 50 studs to the right of the  block
					local vel = Vector2.new(0,object.velocity.Y)
					local pos = Vector2.new(collision.position.X+50,object.position.Y)
					return true,'right',vel,pos
				end
			end
		end
	end
	--return false if it couldn't solve the problem
	return false
end

--run the physics, called each frame
physics.run = function()
	--set up the player object's velocity
	physics.objects.player.velocity = physics.objects.player.velocity-Vector2.new(0,1)
	physics.objects.player.velocity = physics.objects.player.velocity+physics.objects.player.staticVelocity
	local globalPlayerVelocity = physics.objects.player.velocity
	
	--set up the player's position from camera plus movement
	Camera = Camera+physics.objects.player.velocity
	local globalPlayerPosition = Vector2.new(Camera.X*-1,Camera.Y*-1)+Vector2.new(screenSize.X/2+15,375)
	physics.objects.player.position = globalPlayerPosition
	
	--get all collisions(Vector2 playerPosiiton,Vector2 playerSize, only check objects on screen)
	local collisions = physics.getCollisions(globalPlayerPosition,Vector2.new(20,75),true)
	
	--loop through objects on the screen
	for i,v in pairs(collisions) do
		
		--check if should repeat
		local rep = false
		
		--to carry the side variable
		local side
		
		--to stop an infinite loop
		local i = 0
		
		repeat
			--add 1 to i
			i = i + 1
			--if i is greater than max loop
			if i > MAXREPEAT then
				--stop the loop
				print('Forcing break loop')
				break
			end
			--call react to collision to get if it should repeat, what side it collided with, and what the player's velocity and position should be.
			--called with the collision, the player object, last position, and the player's size
			local rep,side,vel,pos = physics.reactToCollision(v,physics.objects.player,physics.objects.player.position-physics.objects.player.velocity,Vector2.new(20,75))
			
			--set love color to red
			love.graphics.setColor(255,0,0,50)
			
			--draw a red box where there was a collision
			love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,50)
			
			--check if the collision should happen based on surface
			if rep and physics.checkSmoothSurface((v.position-Vector2.new(0,450))/50,side) then
				
				--apply the vel and posiiton changes
				physics.objects.player.velocity = vel
				physics.objects.player.position = pos
				
				--if touched top, recent jumping
				if side == 'top' then
					characterMovement.jumpDB = 0
				end
				--set draw color to black
				love.graphics.setColor(0,0,0,255)
				
				--draw a black square for which side has collided
				if side == 'top' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,5)
				elseif side == 'left' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,5,50)
				elseif side == 'right' then
					love.graphics.rectangle('fill',v.position.X+Camera.X+45,v.position.Y+Camera.Y,5,50)
				elseif side == 'bottom' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y+45,50,5)
				end
				--reset color
				love.graphics.setColor(255,255,255)
			end
			--loop until repeat is false
		until not rep
	end

	-----------------------------------------------------------------Second point to help debug physics
	--Exact copy of above, allows the player not to go through knee high blocks
	local collisions = physics.getCollisions(globalPlayerPosition,Vector2.new(20,60),true)
	for i,v in pairs(collisions) do
		local rep = false
		local side
		local i = 0
		repeat
			i = i + 1
			if i > MAXREPEAT then
				break
			end
			local rep,side,vel,pos = physics.reactToCollision(v,physics.objects.player,physics.objects.player.position-physics.objects.player.velocity,Vector2.new(20,60))
			love.graphics.setColor(0,255,0,50)
			love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,50)
			if rep and physics.checkSmoothSurface((v.position-Vector2.new(0,450))/50,side) then
				physics.objects.player.velocity = vel
				physics.objects.player.position = pos
				if side == 'top' then
					characterMovement.jumpDB = 0
				end
				--local mapBlock = (v.position-Vector2.new(0,450))/50
				--love.graphics.setColor(255,255,255)
				love.graphics.setColor(0,0,0,255)
				if side == 'top' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,5)
				elseif side == 'left' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,5,50)
				elseif side == 'right' then
					love.graphics.rectangle('fill',v.position.X+Camera.X+45,v.position.Y+Camera.Y,5,50)
				elseif side == 'bottom' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y+45,50,5)
				end
				love.graphics.setColor(0,255,0)
				local last = physics.objects.player.position-physics.objects.player.velocity
				love.graphics.line(last.X,last.Y,physics.objects.player.position.X,physics.objects.player.position.Y)
				love.graphics.setColor(255,255,255)
			end
		until not rep
	end
	Camera = (physics.objects.player.position-Vector2.new(screenSize.X/2+15,375))*-1
	if physics.objects.player.velocity.X ~= 0 then
		physics.objects.player.velocity = physics.objects.player.velocity-physics.objects.player.staticVelocity
	end
end