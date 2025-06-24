function dodebug(str,id,timeout)
	--term.setBackgroundColor(color.path)
	--term.setTextColor(color.black)
	--term.setCursorPos(15,8)
	--term.write("debug added, str:"..str.." id:"..id)
	local match = 0
	for k,v in ipairs(debugs) do
		if v["id"] == id then
				match = k
		end
	end
	if match ~= 0 then
		debugs[match]["str"] = str
	else
		debugs[#debugs+1] = {["str"]=str,["id"]=id,["t"]=timeout}
	end
	for k,v in ipairs(debugs) do
		if debugs[k]["t"] then
				debugs[k]["t"] = debugs[k]["t"] - 1
				if debugs[k]["t"] == 0 then
					table.remove(debugs,k)
				end
		end
	end
end
function papertoxy(paperpos)
	local x = w/2-pw/2+paperpos.pos-1
	local y = 3+paperpos.line-viewlineoffset
	return x,y
end
function xytopaper(x,y)
	local paperpos = {}
	paperpos.pos = math.max(math.min(x-w/2 + pw/2 + 1,pw),1)
	paperpos.line = math.max(math.min(y - 3 + viewlineoffset,ph),1)
	return paperpos
end
function checkoffsetview()
	if (cursorpos.line < 10) and (viewlineoffset > (cursorpos.line - 2)) then
		viewlineoffset = cursorpos.line - 2
	elseif cursorpos.line > 12 and (viewlineoffset < (cursorpos.line - 14)) then
		viewlineoffset = cursorpos.line - 14
	end
end
function checkincrementcursor()
	if cursorpos.pos == pw and cursorpos.line ~= ph then
		cursorpos.line = cursorpos.line + 1
		cursorpos.pos = 1
	else
		cursorpos.pos = math.min(cursorpos.pos + 1,pw)
	end
	checkoffsetview()
end
function checkdecrementcursor()
	if cursorpos.pos == 1 and cursorpos.line ~= 1 then
		cursorpos.line = cursorpos.line - 1
		cursorpos.pos = pw
	else
		cursorpos.pos = math.max(cursorpos.pos - 1,1)
	end
	checkoffsetview()
end
function paperserialize()
	local alllines = ""--concat all paper lines to one string
	for k,v in ipairs(paper) do
		alllines = alllines..v
	end
	
	local allinespos = pw*(cursorpos.line-1)+cursorpos.pos--convert cursor pos to pos in alllines string

	return alllines, allinespos
end


color = {
	white = 0x1,
	black = 0x8000,
	lgray = 0x100,
	dgray = 0x80,
	orange = 0x2,
	green = 0x20,
	background = term.getBackgroundColor(),
	path = 0x80
}

eventkeys = {
	["up"] = function()
		dodebug("up","c",14)
		cursorpos.line = math.max(cursorpos.line - 1,1)
		checkoffsetview()
	end,
	["down"] = function()
		dodebug("down","d",14)
		cursorpos.line = math.min(cursorpos.line + 1,ph)
		checkoffsetview()
	end,
	["left"] = function()
		dodebug("left","e",14)
		checkdecrementcursor()
	end,
	["right"] = function()
		dodebug("right","f",14)
		checkincrementcursor()
	end,
	["enter"] = function()
		dodebug("enter","g",14)
		if not (cursorpos.line == ph) then
				cursorpos.pos = 1
				cursorpos.line = cursorpos.line + 1
		end
		checkoffsetview()
	end,
	["home"] = function()
		dodebug("home","h",14)
		cursorpos.pos = 1
	end,
	["end"] = function()
		dodebug("end","i",14)
		cursorpos.pos = pw
	end,
	["backspace"] = function()
		dodebug("backspace","j",14)

		checkdecrementcursor()

		--if not (paper[cursorpos.line]:sub(cursorpos.pos,cursorpos.pos) == "\007") then
				local alllines, allinespos = paperserialize()

				local nextempty = alllines:find("\007",allinespos)
				if nextempty then
					local uptobackspc = alllines:sub(1,allinespos-1)
					local afterbackspctoempty = alllines:sub(allinespos+1,nextempty-1)
					local startofemptytoend = alllines:sub(nextempty)

					alllines = uptobackspc..afterbackspctoempty.."\007"..startofemptytoend
					for i = 1,ph do
							paper[i] = alllines:sub(pw*(i-1)+1,pw*i) 
					end
				else--no empty at all left in document:
					
					-- need to handle this case later

				end
		--end
	end,
	["delete"] = function()
		dodebug("del","o",14)

		if not (cursorpos.line == ph and cursorpos.pos == pw) then
				local alllines, allinespos = paperserialize()

				local nextempty = alllines:find("\007",allinespos)
				if nextempty then
					local uptobackspc = alllines:sub(1,allinespos-1)
					local afterbackspctoempty = alllines:sub(allinespos+1,nextempty-1)
					local startofemptytoend = alllines:sub(nextempty)

					alllines = uptobackspc..afterbackspctoempty.."\007"..startofemptytoend
					for i = 1,ph do
							paper[i] = alllines:sub(pw*(i-1)+1,pw*i) 
					end
				else--no empty at all left in document:
					
					-- need to handle this case later

				end
		end
	end,
	["leftAlt"] = function()
		dodebug("leftAlt","p",14)
		--save
		local tempwriter = io.open("pulldir/pullcsv","w+")
		tempwriter:write(csvstring)
	end,
	["rightAlt"] = function()
		dodebug("rightAlt","q",14)
		--print
	end
}
--[[
	"leftAlt"
	"leftCtrl"
	"leftShift"
]]

--[[ todo
	toggleable insert, shown in utility bar
	ctrl left / right
	ctrl home / end
	saving feature
	printing feature
]]
version = 1.1
args = {...}
debugs = {}       
cursorpos = {line=1,pos=1}
w,h = term.getSize()--51,19
pw,ph = 25,21
viewlineoffset=-1

--set up paper data
if args[2] then
	local tempread = fs.open("latest_paper","r")
	if not (type(tempread) == "table") then
		--if file handle cannot be successfully established
		error("unghh~ nyaaa~")
	end
	--read serialized version of last paper to a string !
	local latest_paper = tempread.readAll()
	tempread:close()

	--deserialize and put into paper table!
	for i = 1,ph do
		paper[i] = latest_paper:sub(pw*(i-1)+1,pw*i) 
	end
else
	--make doc
	paper = {}
	for i = 1,ph do
		paper[i] = string.rep("\007",pw)
	end
end

while true do

	---- HANDLE INPUT ----
	local event = {os.pullEvent()}
	
	if event[1] == "key" then--[2]->key, [3]->is_held
		for k,v in pairs(eventkeys) do
				if keys.getName(event[2]) == k then
					eventkeys[keys.getName(event[2])](event[2])
				end
		end
	elseif event[1] == "char" then--[2]->character
		if false then
				paper[cursorpos.line] = paper[cursorpos.line]:sub(1,cursorpos.pos-1)..event[2]..paper[cursorpos.line]:sub(cursorpos.pos+1)
				checkincrementcursor()
		else
				local alllines, allinespos = paperserialize()

				local nextempty = alllines:find("\007",allinespos)

				if nextempty then
					local uptochar = alllines:sub(1,allinespos-1)
					local afterchartoempty = alllines:sub(allinespos,nextempty-1)
					local afteremptytoend = alllines:sub(nextempty+1)

					alllines = uptochar..event[2]..afterchartoempty..afteremptytoend
					for i = 1,ph do
							paper[i] = alllines:sub(pw*(i-1)+1,pw*i) 
					end
					checkincrementcursor()
				end
		end

	elseif event[1] == "mouse_scroll" then--[2]->dir, [3]->x, [4]->y
		viewlineoffset = math.min(math.max(viewlineoffset + event[2],-2),8)
		dodebug("vline "..viewlineoffset,"k",40)

	elseif event[1] == "mouse_click" then--[2]->button, [3]->x, [4]->y
		dodebug("click","l",14)
		cursorpos = xytopaper(event[3],event[4])
		checkoffsetview()
	end
	

	---- DRAW PAGE ----
	term.setBackgroundColor(color.dgray)
	term.clear()

	--paper
	for i = 1,(h-2) do
		local index = math.min(viewlineoffset,8)-1+i
		if paper[index] then
				term.setBackgroundColor(color.white)
				term.setTextColor(color.black)
				term.setCursorPos(w/2-pw/2,(i+2))
				term.write(paper[index]:gsub("\007", " "))
				--term.write(paper[index])

				term.setBackgroundColor(color.dgray)
				term.setTextColor(color.lgray)
				term.setCursorPos(w/2-pw/2-tostring(index):len(),(i+2))
				term.write(index)
		end
	end

	--cursor
	term.setBackgroundColor(color.green)
	term.setTextColor(color.black)
	term.setCursorPos(papertoxy(cursorpos))
	--term.write(paper[cursorpos.line]:sub(cursorpos.pos,cursorpos.pos))
	term.write(paper[cursorpos.line]:sub(cursorpos.pos,cursorpos.pos):gsub("\007", " "))

	--text top left
	term.setBackgroundColor(color.dgray)
	term.setCursorPos(1,1)
	term.setTextColor(color.lgray)
	term.write("v "..version.." - ")
	term.setTextColor(color.white)
	term.write("Grugtype Basic")
	
	--text top right
	str = "x:"..w.." y:"..h
	term.setCursorPos(w-(str:len())+1,1)
	term.setTextColor(color.lgray)
	term.write(str)

	--utility bar
	term.setCursorPos(1,2)
	term.setBackgroundColor(color.lgray)
	term.write(string.rep(" ",w))

	---- DEBUG ----
	dodebug("cline "..cursorpos.line,"a")
	dodebug("cpos "..cursorpos.pos,"b")
	term.setBackgroundColor(color.orange)
	term.setTextColor(color.black)
	
	for k,v in ipairs(debugs) do
		term.setCursorPos(w/2+pw/2,4+k)
		term.write(v.str)
	end
end