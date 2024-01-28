--[[
todo

]]

color = {
      white = 0x1,
      black = 0x8000,
      lgray = 0x100,
      dgray = 0x80,
      background = term.getBackgroundColor(),
      path = 0x80
}

version = 1.1

w,h = term.getSize()--51,19
pw,ph = 25,21

term.setBackgroundColor(color.dgray)
term.clear()

--text top left
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
term.setTextColor(color.lgray)
term.write(string.rep(" ",w))

--paper
term.setBackgroundColor(color.white)
for i = 3,h do
      term.setCursorPos(w/2-pw/2,i)
      term.write(string.rep(" ",pw))
end


while true do
      
end