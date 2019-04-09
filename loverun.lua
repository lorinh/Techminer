----------------
---love.run
----------------
--slightly edited version of default love.run
----------------

function love.run()

    if love.event then
        love.event.pump()
    end

    if love.load then love.load(arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
						if save.initialized == true then
							save.saveFile(menu.saveName)
						end
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end
		
        if love.window and love.graphics and love.window.isCreated() then
            love.graphics.clear()
            love.graphics.origin()
            if love.draw then love.draw(dt) end
			--local l = love.timer.getTime()
            love.graphics.present()
			--print(1/(love.timer.getTime()-l))
        end

        --if love.timer then love.timer.sleep(0.001) end
    end

end
