--VAR SETUP
moves,estfuel,beginfuel = 0,0,0


--GLOBAL FUNCTIONS 		vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
function round(val)
	if val%1 >= 0.5 then
		return math.ceil(val)
	else
		return math.floor(val)
	end
end
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
function fuellimit()
	return turtle.getFuelLimit()
end
function fuelpercent()
	return round((fuellevel()/fuellimit())*100)
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
function back()
	turtle.back()
	moves = moves+1
	checkrefuel()
	checkannouncefuel()
end

function err(cause)
    print(cause..", stopping.")
    print(1+nil)
end

function safedig()
	turtle.dig()
	while turtle.detect() do
		turtle.dig()
	end
end
function safedigup()
	while turtle.detectUp() do
		turtle.digUp()
	end
	up()
end
function safedigdown()
	while turtle.detectDown() do
		turtle.digDown()
	end
	down()
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
		write(arg.prefix)
		args[currentarg].val = read()
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

print("volfill started, volume includes turtle, y forw/back, x left/right, z up/down")

validateinputs()

removeprefixes()

print("Turtle has "..fuellevel().." fuel, which is "..fuelpercent().."%")
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

beginfuel = fuellevel()

print("Starting volume fill")
print("	---	")

--[[
if dirver == "d" then
	for i = 1,(z-1) do
		excavateXY()
		digdown()
	end
	excavateXY()
else
	for i = 1,(z-1) do
		excavateXY()
		safedigup()
	end
	excavateXY()
end]]
if dirver == "u" then
	turtle.turnRight()
	turtle.turnRight()

	for i = 1,y-1 do
		turtle.place()
		back()
	end
else

end
print("Volume filled, turtle has stopped.")
print("	---	")

spentfuel = beginfuel-fuellevel()

if fuellevel() == 0 then
	print("Turtle is out of fuel.")
	print(beginfuel.." fuel was spent.")
else
	print("Turtle has "..fuellevel().." fuel remaining, which is "..fuelpercent().."% of full capacity.")
	print(spentfuel.." fuel was spent, "..round(spentfuel/fuellevel()*100).."% of starting amount.")
end