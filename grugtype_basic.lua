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
            dodebug("up pressed","c",14)
            cursorpos.line = math.max(cursorpos.line - 1,1)
      end,
      ["down"] = function()
            dodebug("down pressed","d",14)
            cursorpos.line = math.min(cursorpos.line + 1,ph)
      end,
      ["left"] = function()
            dodebug("left pressed","e",14)
            if cursorpos.pos == 1 and cursorpos.line ~= 1 then
                  cursorpos.line = cursorpos.line - 1
                  cursorpos.pos = pw
            else
                  cursorpos.pos = math.max(cursorpos.pos - 1,1)
            end
      end,
      ["right"] = function()
            dodebug("right pressed","f",14)
            if cursorpos.pos == pw and cursorpos.line ~= ph then
                  cursorpos.line = cursorpos.line + 1
                  cursorpos.pos = 1
            else
                  cursorpos.pos = math.min(cursorpos.pos + 1,pw)
            end
      end,
      ["enter"] = function()
            dodebug("enter pressed","g",14)
            if not (cursorpos.line == ph) then
                  cursorpos.pos = 1
                  cursorpos.line = cursorpos.line + 1
            end
      end,
      ["home"] = function()
            dodebug("home pressed","h",14)
            cursorpos.pos = 1
      end,
      ["end"] = function()
            dodebug("end pressed","i",14)
            cursorpos.pos = pw
      end,
      ["backspace"] = function()
            dodebug("backspace pressed","j",14)
            if cursorpos.pos == 1 and cursorpos.line ~= 1 then
                  cursorpos.line = cursorpos.line - 1
                  cursorpos.pos = pw
            else
                  cursorpos.pos = math.max(cursorpos.pos - 1,1)
            end
            paper[cursorpos.line] = paper[cursorpos.line]:sub(1,cursorpos.pos-1).."\007"..paper[cursorpos.line]:sub(cursorpos.pos+1)
            
      end
}
--[[
"leftAlt"
"leftCtrl"
"leftShift"]]

--[[todo
      ctrl left right
      ctrl home ctrl end
      view moving with cursor
      saving feature
      printing feature]]

version = 1.1
debugs = {}       
cursorpos = {line=1,pos=1}
w,h = term.getSize()--51,19
pw,ph = 25,21
viewlineoffset=0

--set up paper data
paper = {}
for i = 1,ph do
      paper[i] = string.rep("\007",pw)
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
            else
                  dodebug("len:"..paper[cursorpos.line]:len(),"len",20)
                  local nextempty = paper[cursorpos.line]:find("\007",cursorpos.pos)

                  if nextempty then
                        local uptochar = paper[cursorpos.line]:sub(1,cursorpos.pos-1)
                        local afterchartoempty = paper[cursorpos.line]:sub(cursorpos.pos,nextempty-1)
                        local afteremptytoend = paper[cursorpos.line]:sub(nextempty+1)
                        
                        paper[cursorpos.line] = uptochar..event[2]..afterchartoempty..afteremptytoend
                        dodebug("len2:"..paper[cursorpos.line]:len(),"len2",20)
                  else
                        local nohome = true
                        while nohome do
                              --[[
                              if there is a free spot on the line+1 then
                                    line = uptochar..event[2]..afterchartoendminus1char
                                    line+1 = linelastchar..uptoempty..afteremptytoend
                              elseif there is a free spot on line+2 then
                                    line = is uptochar..event[2]..afterchartoendminus1char
                                    line+1 = linelastchar..wholeline+1minus1char
                                    line+2 = line+1lastchar..uptoempty..afteremptytoend
                              ]]
                        end
                  end
            end
            if cursorpos.pos == pw and cursorpos.line ~= ph then
                  cursorpos.line = cursorpos.line + 1
                  cursorpos.pos = 1
            else
                  cursorpos.pos = math.min(cursorpos.pos + 1,pw)
            end

      elseif event[1] == "mouse_scroll" then--[2]->dir, [3]->x, [4]->y
            viewlineoffset = math.min(math.max(viewlineoffset + event[2],-2),8)
            dodebug("scrolled "..viewlineoffset,"k",40)

      elseif event[1] == "mouse_click" then--[2]->button, [3]->x, [4]->y
            dodebug("clicked","l",14)
            cursorpos = xytopaper(event[3],event[4])
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
      term.write(paper[cursorpos.line]:sub(cursorpos.pos,cursorpos.pos))

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
      dodebug("line "..cursorpos.line,"a")
      dodebug("pos "..cursorpos.pos,"b")
      term.setBackgroundColor(color.orange)
      term.setTextColor(color.black)
      
      for k,v in ipairs(debugs) do
            term.setCursorPos(w/2+pw/2,4+k)
            term.write(v.str)
      end
end