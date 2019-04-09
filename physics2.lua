----------------
---physics
----------------
--notes
--uses map as hitboxes, each block being 50x50
--only tests 4 points of player(using localCamera+Vector2.new(0,450))
--vertexes of player are (20,0),(0,75),(0,0),(20,75)
----------------

local DEBUG_PHYSICS = false

physics = {}

physics.objects = {}


 function physics.init()
	physics.objects.player = {}
	physics.objects.player.velocity = Vector2.new(0,0)
	physics.objects.player.staticVelocity = Vector2.new(0,0)
	physics.objects.player.position = Vector2.new(0,0)
end

 function physics.getCollisions(position,size,group)
	local collisions = {}
	local xStart = -(Camera.X-Camera.X%50)/50
	local yStart = -(Camera.Y-Camera.Y%50)/50
	local map = map:getMap()
	for xIndex = xStart-1,xStart+25 do
		for yIndex = yStart-6,yStart+10 do
			local value = map[xIndex] and map[xIndex][yIndex] or nil
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
							collisions[#collisions+1] = {position = blockPosition,vertex = v,block = value,size = Vector2.new(50,50)}
							
						end
					end
				end
			end
		end
	end
	return collisions
end

 function physics.checkSmoothSurface(object,face)
	if face then
		local map = map:getMap()
		normals = {left   =    Vector2.new(-1,0),
				   right  =    Vector2.new(1,0),
				   top    =    Vector2.new(0,-1),
				   bottom =    Vector2.new(0,1)}

		local x,y = object.X+normals[face].X, object.Y+normals[face].Y
		if map[x] and (map[x][y] ~= 'air' and map[x][y] ~= nil and data.itemInfo[map[x][y]].physics ~= false) then
			return false
		end
	end
	
	--otherwise return true
	return true
end

function physics.min(...)
	args = {...}
	local min = math.huge
	local label = nil
	local second = nil
	for i = 1,#args,2 do
		if args[i] < min then
			second = label
			min = args[i]
			label = args[i+1]
		end
	end
	return label, second
end

--self[pos,vel,size],object[pos,size,vertex,block],checkground{bool}
 function physics.reactToCollision(self,object,checkGround)
	local top    =   object.position + Vector2.new(object.size.X/2,0)
	local bottom =   object.position + Vector2.new(object.size.X/2,object.size.Y)
	local left   =   object.position + Vector2.new(0,object.size.Y/2)
	local right  =   object.position + Vector2.new(object.size.X,object.size.Y/2)
	
	local vertexPos = self.position+object.vertex
	
	local topDistance    =   magnitude(top-vertexPos)
	local bottomDistance =   magnitude(bottom-vertexPos)
	local leftDistance   =   magnitude(left-vertexPos)
	local rightDistance  =   magnitude(right-vertexPos)
	
	local minDistance, second = physics.min(topDistance    ,  'top'   ,
		                            		bottomDistance ,  'bottom',
											leftDistance   ,  'left'  ,
											rightDistance  ,  'right' )
	
	if minDistance == 'top' and object.vertex.Y ~= 0 then
		local pos = Vector2.new(self.position.X,object.position.Y-self.size.Y)
		local vel = Vector2.new(self.velocity.X,0)
		return pos,vel,'top',second
	elseif minDistance == 'bottom' then
		local pos = Vector2.new(self.position.X,object.position.Y+object.size.Y)
		local vel = Vector2.new(self.velocity.X,0)
		return pos,vel,'bottom',second
	elseif minDistance == 'left' then
		local pos = Vector2.new(object.position.X-self.size.X,self.position.Y)
		local vel = Vector2.new(0,self.velocity.Y)
		return pos,vel,'left',second
	elseif minDistance == 'right' then
		local pos = Vector2.new(object.position.X+object.size.X,self.position.Y)
		local vel = Vector2.new(0,self.velocity.Y)
		return pos,vel,'right',second
	else
		return nil
	end
end

function physics.forceSide(self,object,checkGround,minDistance)
	if minDistance == 'top' and object.vertex.Y ~= 0 then
		local pos = Vector2.new(self.position.X,object.position.Y-self.size.Y)
		local vel = Vector2.new(self.velocity.X,0)
		return pos,vel,'top'
	elseif minDistance == 'bottom' then
		local pos = Vector2.new(self.position.X,object.position.Y+object.size.Y)
		local vel = Vector2.new(self.velocity.X,0)
		return pos,vel,'bottom'
	elseif minDistance == 'left' then
		local pos = Vector2.new(object.position.X-self.size.X,self.position.Y)
		local vel = Vector2.new(0,self.velocity.Y)
		return pos,vel,'left'
	elseif minDistance == 'right' then
		local pos = Vector2.new(object.position.X+object.size.X,self.position.Y)
		local vel = Vector2.new(0,self.velocity.Y)
		return pos,vel,'right'
	else
		return nil
	end
end

function physics.run(delta)
	characterMovement.jumpDB = 0
	local delta = delta*50
	
	local self = {}
	
	self.velocity = physics.objects.player.velocity-Vector2.new(0,0.5)*delta+physics.objects.player.staticVelocity
	
	Camera = Camera+self.velocity*delta
	
	self.position = Vector2.new(Camera.X*-1,Camera.Y*-1)+Vector2.new(screenSize.X/2+15,375)

	self.size = Vector2.new(20,75)
	
	local collisions = physics.getCollisions(self.position,self.size,true)
	
	for i,v in pairs(collisions) do
		local pos,vel,side,second = physics.reactToCollision(self,v,true)
		local blockPosition = (v.position-Vector2.new(0,450))/50
		if pos and physics.checkSmoothSurface(blockPosition,side) then
			if DEBUG_PHYSICS == true then
				love.graphics.setColor(255,0,0)
				love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,50)
				
				love.graphics.setColor(0,0,0)
				if side == 'top' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,5)
				elseif side == 'left' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,5,50)
				elseif side == 'right' then
					love.graphics.rectangle('fill',v.position.X+Camera.X+45,v.position.Y+Camera.Y,5,50)
				elseif side == 'bottom' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y+45,50,5)
				end
				
				love.graphics.setColor(255,255,255)
			end
			
			if side == 'top' then
				characterMovement.jumpDB = 0
			end
			self.position = pos
			self.velocity = vel
		elseif pos and physics.checkSmoothSurface(blockPosition,second) then
			if DEBUG_PHYSICS == true then
				love.graphics.setColor(255,0,0)
				love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,50)
				
				love.graphics.setColor(0,0,0)
				if side == 'top' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,5)
				elseif side == 'left' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,5,50)
				elseif side == 'right' then
					love.graphics.rectangle('fill',v.position.X+Camera.X+45,v.position.Y+Camera.Y,5,50)
				elseif side == 'bottom' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y+45,50,5)
				end
				
				love.graphics.setColor(255,255,255)
			end
			local pos,vel,side = physics.forceSide(self,v,true)

			if side == 'top' then
				characterMovement.jumpDB = 0
			end
			if pos then
				self.position = pos
				self.velocity = vel
			end
		end
	end
	
	self.size = Vector2.new(14,65)
	
	local collisions = physics.getCollisions(self.position+Vector2.new(3,0),self.size,true)
	
	for i,v in pairs(collisions) do
		local pos,vel,side = physics.reactToCollision(self,v,true)
		local blockPosition = (v.position-Vector2.new(0,450))/50
		if pos and physics.checkSmoothSurface(blockPosition,side) then
			if DEBUG_PHYSICS == true then
				love.graphics.setColor(255,0,0)
				love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,50)
				
				love.graphics.setColor(0,0,0)
				if side == 'top' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,50,5)
				elseif side == 'left' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y,5,50)
				elseif side == 'right' then
					love.graphics.rectangle('fill',v.position.X+Camera.X+45,v.position.Y+Camera.Y,5,50)
				elseif side == 'bottom' then
					love.graphics.rectangle('fill',v.position.X+Camera.X,v.position.Y+Camera.Y+45,50,5)
				end
				
				love.graphics.setColor(255,255,255)
			end
			if side == 'top' then
				characterMovement.jumpDB = 0
			end
			self.position = pos
			self.velocity = vel
		end
	end
	
	Camera = (self.position-Vector2.new(screenSize.X/2+15,375))*-1
	if self.velocity.X ~= 0 then
		self.velocity = self.velocity-physics.objects.player.staticVelocity
	end
	physics.objects.player.velocity = self.velocity
end