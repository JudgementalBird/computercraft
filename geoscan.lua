maxradius = 16

radius, filterword, listxyz = ...
radius = tonumber(radius)
x,y = term.getSize()
term.clear()

--funcs
function scan()
	geo = peripheral.find("geoScanner")
	return geo.scan(radius)
end

function within(a,index)
	for k,v in pairs(a) do
		if k == index then
			return true
		end
	end
end

function length(a)
	local len = 0
	for k,v in pairs(a) do
		len = len + 1
	end
	return len
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


--logic
if not radius then
	print("Needs radius to search.")
	print("\nFilter with second arg, only lists blocks with the filter anywhere in name.")
	print("\nIf '@' in filter arg, searches the section describing block origin, eg 'minecraft:', 'create:'")
	print("\nList XYZ of all returns with third arg, y/n.")
	print("\ngeoscan\n(radius)\n[[@]filter]\n[y/n]")
	error()
elseif (radius < 1) then
	print("Negative radius?? no")
	error()
elseif (radius > maxradius) then
	print("High radius (~12<) can cause instability and crashes in computercraft, this program has a default max allowed radius of 16.\nIf you want to try higher radius anyway, edit 'maxradius' at the top of this file")
	error()
elseif not (type(listxyz) == "nil") and not listxyz:find("y") and not listxyz:find("n")  then
	print("Third arg should include 'y' or 'n'")
	error()
end
--at this point, radius is provided and valid

blocklist = scan()
blocks = 0
foundblocks = {}
if not filterword then
	--no filter
	print("No filter provided, listing amount of everything.\n---")
	for k,v in ipairs(blocklist) do
		if within(foundblocks,v.name) then
			foundblocks[v.name].count = foundblocks[v.name].count + 1
			foundblocks[v.name].pos[length(foundblocks[v.name].pos)+1] = vector.new(v.x,v.y,v.z)
		else
			foundblocks[v.name] = {count = 1, pos = {[1]=vector.new(v.x,v.y,v.z)}}
		end
		blocks = blocks + 1
	end
else
	--filter
	print("Filter provided, listing matches.\n---")
	for k,v in ipairs(blocklist) do
		if within(foundblocks,v.name) then--if the name of the block iterated over is used as index in foundblocks table, eg if we have seen this block before:
			foundblocks[v.name].count = foundblocks[v.name].count + 1
			foundblocks[v.name].pos[length(foundblocks[v.name].pos)+1] = vector.new(v.x,v.y,v.z)
		else
			local _,pos = v.name:find(":")
			if filterword:find("@") then
				relevantpart = v.name:sub(1,pos-1)
			else
				relevantpart = v.name:sub(pos+1,-1)
			end
			--print(relevantpart)
			if relevantpart:find(filterword:gsub("@","")) then
				foundblocks[v.name] = {count = 1, pos = {[1]=vector.new(v.x,v.y,v.z)}}
			end
		end
		blocks = blocks + 1
	end
end

print("There are "..blocks.." blocks within the "..(radius*2+1).."^3 cube around you.")
if length(foundblocks) > 0 then
	if length(foundblocks) > 0 then
		print("Found:")
		for k,v in pairs(foundblocks) do
			print(v.count.." "..k)
			if listxyz and listxyz:find("y") then
				for k,v in ipairs(v.pos) do
					print(k.." {"..v:tostring().."}")
					sleep(0.05)
				end
			end
			if blocks >= y then
				sleep(0.3)
			end
		end
	end
else
	if filterword then
		print("None that match the pattern you gave though.")
	end
end
