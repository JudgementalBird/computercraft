color = {
      boring = 0x100,
      warning = 0x2,
      operation = 0x200,
      userfailure = 0x4000,
      progfailure = 0x400,
      success = 0x2000,
      background = term.getBackgroundColor(),
      path = 0x80
}

version = 1
term.setTextColor(color.boring)
print("v "..version)