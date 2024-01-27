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
original = "pulldir/ not found, making"
pathsection = "77777777"
term.blit(original,string.rep("9",original:len()),pathsection..string.rep("f",original:sub(pathsection:len()+1):len()))
