--[[todo:
make x and y functions work with 1 value
revamp refuel function so it doesn't unnecessarily combust items
give time predictions on start
]]



--VAR SETUP
moves,estfuel = 0,0


--GLOBAL FUNCTIONS 		vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
function refuel()
	--add check for if fuel is or will be full before combusting
	for i = 1,16 do
		turtle.select(i)
		if turtle.refuel(0) then
			turtle.refuel()
			print("Combusted items from slot "..i)
		end
	end
	print("	---	")
end
function checkrefuel()
	if (moves % 20 == 0) then
		refuel()
	end
end
function fuellevel()
	return turtle.getFuelLevel()
end
function fuelpercent()
	return (fuellevel()/20000)*100
end
function checkannouncefuel()
	if (moves % 100 == 0) then 
		print("Periodic update:")
		print("Turtle has "..fuellevel().." fuel, "..fuelpercent().."% remaining.")
		print("	---	")
	end
end
function up()
	turtle.up()
	moves = moves+1
	checkrefuel()
	checkannouncefuel()
end
function forward()
	turtle.forward()
	moves = moves+1
	checkrefuel()
	checkannouncefuel()
end
function down()
	turtle.down()
	moves = moves+1
	checkrefuel()
	checkannouncefuel()
end
function safedig()
	turtle.dig()
	while turtle.detect() do
		turtle.dig()
	end
end
function err(cause)
    print(cause..", stopping.")
    print(1+nil)
end
function digup()
	turtle.digUp()
	up()
end
function digdown()
	turtle.digDown()
	down()
end
function digturnleft()
	--turn around left
	turtle.turnLeft()
	safedig()
	forward()
	turtle.turnLeft()
	dirhor = "r"
end
function digturnright()
	--turn around right
	turtle.turnRight()
	safedig()
	forward()
	turtle.turnRight()
	dirhor = "l"
end
function excavateY()
	--dig one row y
	for i = 1,(y-1) do
		safedig()
		forward()
	end
end
function excavateXY()
	--for each of x
	for i = 1,(x-1) do
		excavateY()
		if dirhor == "l" then
			digturnleft()
		else
			digturnright()
		end
	end
	excavateY()
	if dirhor == "l" then
		turtle.turnRight()
		turtle.turnRight()
		dirhor = "l"
	else
		turtle.turnLeft()
		turtle.turnLeft()
		dirhor = "r"
	end
end
--GLOBAL FUNCTIONS	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


argdirhor, argdirver, argx, argy, argz, argpullfrominv = ...

args = {
    {   
		name = "argdirhor",
		val = argdirhor,
		type = "text",
		valids = {"l","r"},
		prefix = "direction L/R: "
	},
	{
		name = "argdirver",
		val = argdirver,
		type = "text",
		valids = {"u","d"},
		prefix = "direction U/D: "
	},
	{
		name = "argx",
		val = argx,
		type = "number",
		prefix = "X size: "
	},
	{
		name = "argy",
		val = argy,
		type = "number",
		prefix = "Y size: "
	},
	{
		name = "argz",
		val = argz,
		type = "number",
		prefix = "Z size: "
	},
	{
		name = "argpullfrominv",
		val = argpullfrominv,
		type = "text",
		valids = {"y","n"},
		prefix = "pull fuel from inv Y/N: "
	},
}

types = {
    number = function(input)
        if tonumber(input.val) then
            return --is a number and greater than 1
        else
            write(input.prefix);input.val = read()
            return types.number(input)
        end
    end,
    text = function(input,currentarg)
        local haserrored = true
        args[currentarg].val = string.lower(input.val)
        for k,v in pairs(input.valids) do
            if input.val == v then haserrored = false end
        end
        if haserrored then
            write(input.prefix);input.val = read()
            return types.text(input,currentarg)
        end
    end
}

function handlearg(arg,currentarg)
    if arg.val ~= nil then
        --value is SOMETHING
        types[arg.type](arg,currentarg)
        return
    else
        write(arg.prefix);args[currentarg].val = read()
        return handlearg(arg,currentarg)
    end
end

function validateinputs()
    for k, v in ipairs(args) do
        handlearg(v,k)
    end
end

function removeprefixes()
    for _,v in ipairs(args) do
        _G[string.sub(v.name,4,#v.name)] = v.val
    end
end

print("volmine started, volume includes turtle, y forw/back, x left/right, z up/down")

validateinputs()

removeprefixes()

print("This turtle has "..fuellevel().." fuel, which is "..fuelpercent().."%")
print("	---	")

estfuel = (x*y*z)-1

print("That will take "..estfuel.." moves.")

if estfuel > fuellevel() then
	print("Turtle doesn't have enough fuel for this, missing "..(estfuel - fuellevel()).." fuel")
	if pullfrominv == "y" then
		pullfrominv = true
	else
		pullfrominv = false
	end
else
	print("Turtle has enough fuel for this, "..( fuellevel() - estfuel ).." to spare")
end

if pullfrominv then refuel() end

print("Starting volume excavation")
print("	---	")

if dirver == "d" then
	for _ = 1,(z-1) do
		excavateXY()
		digdown()
	end
	excavateXY()
else
	for _ = 1,(z-1) do
		excavateXY()
		digup()
	end
	excavateXY()
end
print("Volume mined, turtle has stopped.")