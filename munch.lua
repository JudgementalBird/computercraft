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
	goup = function()
	turtleturtle.up()
		moves = moves+1
	end,
	go = function()
		turtle.forward()
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


--x, y, z = turtle.getWorldPosition()

moves = 0