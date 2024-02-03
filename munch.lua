function round(val)
	return math.floor(val+0.5)
end

fuel = {
	level = turtle.getFuelLevel(),
	max = turtle.getFuelLimit(),
	percentofmax = function()
		return round((fuellevel()/fuellimit())*100)
	end,
	refuel = function()
		shell.run("refuel all")
	end,
	checkinformfuel = function()
		if (moves % 100 == 0) then 
			print("Periodic update:")
			print("Turtle has "..fuellevel().." fuel, "..fuelpercent().."% remaining.")
			print("	---	")
		end
	end
}

loc = {
	go = function()
		turtle.forward()
		moves = moves+1
	end,
	goup = function()
		turtle.up()
		moves = moves+1
	end,
	godown = function()
		turtle.down()
		moves = moves+1
	end,
	turnright = turtle.turnRight,
	turnleft = turtle.turnLeft,
	dig = turtle.dig,
	digup = turtle.digUp,
	digdown = turtle.digDown,
	safedig = function()
		local attempts = 0
		turtle.dig()
		while turtle.detect() do
			if attempts < 40 then
				error("too many dig attempts")
			end
			turtle.dig()
			attempts = attempts + 1
		end
	end,
	safedigup = function()
		local attempts = 0
		turtle.digUp()
		while turtle.detectUp() do
			if attempts < 40 then
				error("too many dig up attempts")
			end
			turtle.digUp()
			attempts = attempts + 1
		end
	end,
	safedigdown = function()
		local attempts = 0
		turtle.digDown()
		while turtle.detectDown() do
			if attempts < 40 then
				error("too many dig down attempts")
			end
			turtle.digDown()
			attempts = attempts + 1
		end
	end
}

function getpos()
	return vector.new(turtle.getWorldPosition())
end

function getfacing()
	local start = vector.new(turtle.getWorldPosition())
	loc.go()

function gotochunkmiddle()
	getpos()
end




moves = 0




--[[
(the direction we start facing is the direction we will continue into)

while true do
	analyze for debris
	if there is debris:
		gotochunkmiddle()
		go to center of the chunk
		check if 
		scan for debris
		switch to pickaxe
		for the amount of debris:
			go/dig to be touching the closest debris
			use the appropriate direction dig function and possibly orient to dig the debris navigated to
		end
	end
	navigate into closest block inside next chunk (next according to starting orientation)
end


]]