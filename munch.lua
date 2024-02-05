--all digging requiring tasks call dig functions, which are responsible for verifying the turtle is holding a pickaxe
--scan is also responsible for verifying the turtle is holding the geoscanner
--all movement functions call go functions, which keep track of turtle moves since program start

--items get put in first few slots, after 6*64 mined blocks the turtle should stop and drop everything thats not geoscanner, pickaxe, or the searched item
--it will usually have last slot selected, for swapping tools

function round(val)
	return math.floor(val+0.5)
end
function pretty(a)
	if type(a) == "table" then
		for k,v in pairs(a) do
			pretty(v)
		end
	else
		print(tostring(a))
	end
end
function copytable(datatable)--copied from internet
  local tblRes={}
  if type(datatable)=="table" then
    for k,v in pairs(datatable) do
      tblRes[copytable(k)] = copytable(v)
    end
  else
    tblRes=datatable
  end
  return tblRes
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
	dig = function()
		verifyusing("pick")
		turtle.dig()
	end,
	digup = function()
		verifyusing("pick")
		turtle.digUp()
	end,
	digdown = function()
		verifyusing("pick")
		turtle.digDown()
	end,
	detect = turtle.detect,
	detectup = turtle.detectUp,
	detectdown = turtle.detectDown,
	safedig = function()
		local attempts = 0
		loc.dig()
		while loc.detect() do
			if attempts > 40 then
				error("too many dig attempts")
			end
			loc.dig()
			attempts = attempts + 1
		end
	end,
	safedigup = function()
		local attempts = 0
		loc.digup()
		while loc.detectup() do
			if attempts > 40 then
				error("too many dig up attempts")
			end
			loc.digup()
			attempts = attempts + 1
		end
	end,
	safedigdown = function()
		local attempts = 0
		loc.digdown()
		while loc.detectdown() do
			if attempts > 40 then
				error("too many dig down attempts")
			end
			loc.digdown()
			attempts = attempts + 1
		end
	end,
	safego = function()
		if loc.detect() then
			loc.safedig()
		end
		loc.go()
	end,
	safegoup = function()
		if loc.detectup() then
			loc.safedigup()
		end
		loc.goup()
	end,
	safegodown = function()
		if loc.detectdown() then
			loc.safedigdown()
		end
		loc.godown()
	end,
	safegoback = function()
		loc.turnleft()
		loc.turnleft()
		loc.safego()
		loc.turnleft()
		loc.turnleft()
	end
}

function verifyusing(thing)
	if not (heldtool == thing) then
		turtle.select(16)
		turtle.equipRight()
		if heldtool == "geo" then
			heldtool = "pick"
		elseif heldtool == "pick" then
			heldtool = "geo"
		else
			error("holding some weird shit")
		end
	end
end

function getpos()
	local vec = vector.new(turtle.getWorldPosition())
	return vec
end

function getfacing()
	local start = getpos()
	loc.safego()
	local difference = start - getpos()
	loc.safegoback()
	print(math.atan2(difference.x,difference.z))
	return difference
end

function gotochunkmiddle()
	getpos()
	print("placeholder go to chunk middle")
end

function scan()
	verifyusing("geo")
	scanner = peripheral.find("geoScanner")
	result = scanner.scan(8)
end

function giveanalyze()
	verifyusing("geo")
	scanner = peripheral.find("geoScanner")
	result = scanner.chunkAnalyze()
end

moves = 0
heldtool = "geo"
facing = getfacing()
loc.turnright()
facing = getfacing()
loc.turnright()
facing = getfacing()
loc.turnright()
facing = getfacing()
loc.turnright()
--initialfacing = copytable(facing)

while false do

	--analyze for debris
	result = giveanalyze()
	debrisinchunk = 0
	for k,v in pairs(result) do
		if k:find("debris") then
			debrisinchunk = debrisinchunk + 1
		end
	end

	--if there is debris
	if debrisinchunk > 0 then
		gotochunkmiddle()

	end
	--navigate into closest block inside next chunk (next according to starting orientation)

end



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