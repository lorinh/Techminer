----------------
---Sound Service
----------------
--allows for overlapping sounds
----------------

soundService = {}

soundService.sounds = {}

function soundService.playSound(name)
	local played = false
	local index = 1
	for i,v in pairs(soundService.sounds[name].files) do
		if not v:isPlaying() and played == false then
			v:play()
			played = true
		end
	end
	if played == false then
		soundService.sounds[name].files[#soundService.sounds[name].files+1] = love.audio.newSource(soundService.sounds[name].source,'static')
		soundService.sounds[name].files[#soundService.sounds[name].files]:play()
	end
end

function soundService.addSound(source)
	local index = #soundService.sounds+1
	local sound = {}
	sound.source = source
	sound.files = {}
	sound.files[1] = love.audio.newSource(source,'static')--create 1 automaticly.

	soundService.sounds[index] = sound
	return {play = function() soundService.playSound(index) end}
end