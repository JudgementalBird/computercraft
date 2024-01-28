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

term.setBackgroundColor(color.white)
term.clear()
term.setTextColor(color.black)

term.setCursorPos(1,1)
version = 1
term.setTextColor(color.lgray)
term.write("v "..version.."   ")
term.setTextColor(color.dgray)
term.write("Grugtype Basic")