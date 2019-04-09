----------------
---Vector2
----------------

magnitude = function(vector)
	return (vector.X^2+vector.Y^2)^.5
end

unit = function(vector)
	return vector/magnitude(vector)
end

Vector2 = {
	new = function(x,y)
		local vec = {X = x,Y = y}
		local meta = {
			__sub = function(self, value)
				local self = vec
				return Vector2.new(self.X-value.X,self.Y-value.Y)
			end,
			__add = function(self,value)
				local self = vec
				return Vector2.new(self.X+value.X,self.Y+value.Y)
			end,
			__mul = function(self,value)
				local self = vec
				return Vector2.new(self.X*value,self.Y*value)
			end,
			__div = function(self,value)
				local self = vec
				return Vector2.new(self.X/value,self.Y/value)
			end,
			__tostring = function(self)
				--local self = Vec
				return tostring(self.X)..' '..tostring(self.Y)
			end
		}
		vec = setmetatable(vec,meta)
		return vec end
	}

