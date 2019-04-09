----------------------
--User events, onscreen text notificaiton
----------------------

userEvent = {}

userEvent.events = {}

function userEvent.draw()
	for i,v in pairs(userEvent.events) do
		print('Drawing')
		love.graphics.printf(v.text,screenSize.X/4,200-v.pos,screenSize.X/2,'center')
		v.pos = v.pos+1
		if v.pos > 200 then
			userEvent.events[i] = nil
		end
	end
	userEvent.events = userEvent.sort(userEvent.events)
end

function userEvent.addEvent(text)
	print('Event added',text)
	userEvent.events[#userEvent.events+1] = {text = text,pos = 0}
end

function userEvent.sort(tab)
	local newTab = {}
	for i,v in pairs(tab) do
		newTab[#newTab+1] = v
	end
	return newTab
end