--[[
todo

]]

color = {
      white = 0x1,
      black = 0x8000,
      background = term.getBackgroundColor(),
      path = 0x80
}

term.setBackgroundColor(color.white)
term.clear()
term.setTextColor(color.black)
print(term.getSize())
--version = 1
--term.setTextColor(color.boring)
--print("v "..version)