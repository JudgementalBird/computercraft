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

version = 1.2
term.setTextColor(color.boring)
print("v "..version)
original = "pulldir/ not found, making"
pathsection = 8
term.blit(original, string.rep("8",pathsection)..string.rep("9",original:len()-pathsection), string.rep("7",pathsection)..string.rep("f", original:sub(pathsection+1):len()))
write("\n")