--[[
todo

implement cut feature

make it use colored text

test thoroughly
]]

color = {
      boring = 0x100,
      warning = 0x2,
      operation = 0x200,
      userfailure = 0x4000,
      progfailure = 0x400,
      success = 0x2000
}

version = 1.2
term.setTextColor(color.boring)
print("v "..version)

function handleurl(theurl)
      http.request(theurl)
      requested = true
      
      while requested do

            event, usedurl, response = os.pullEvent()
            
            if event == "http_success" then
                  
                  term.setTextColor(color.operation)
                  print("http success, file downloaded")
                  responsestring = response.readAll()
                  
                  if usedurl:find("%.lua") then--escape the . with %, effectively "if .lua is in the string then:"
                        filename = usedurl:match("([^/]-)$")
                  else
                        filename = "unknown_download"
                  end

                  local allfiles = fs.list("")
                  for k,v in pairs(allfiles) do--for every path in the top directory:
                        if v:find(filename) then--if chosen filename is found in this path
                              term.setTextColor(color.warning)
                              print("found file by same name, it will be overwritten")
                        end
                  end
                  
                  term.setTextColor(color.operation)
                  print("installing file with filename: "..filename)
                  tempwriter = io.open(filename,"w+")
                  tempwriter:write(responsestring)
                  requested = false

            elseif event == "http_failure" then

                  term.setTextColor(color.progfailure)
                  print("http failure")
                  requested = false 

            end
      end
end

--capture arguments this program was run with
args = {...}

--ensure pulldir/ directory exists
if fs.exists("pulldir/") then
      --print("pulldir/ exists")
else
      term.setTextColor(color.warning)
      print("pulldir/ not found, making")
      fs.makeDir("pulldir/")
      term.setTextColor(color.operation)
      print("pulldir/ made")
end
--at this point pulldir/ must exist, so now ensure the pulldir/pullcsv exists
if fs.exists("pulldir/pullcsv") then
      --print("pulldir/pullcsv exists")
else
      term.setTextColor(color.warning)
      print("pulldir/pullcsv not found, making")
      temp = io.open("pulldir/pullcsv","w")
      temp:close()
      term.setTextColor(color.operation)
      print("pulldir/pullcsv made")
end
--at this point pulldir/ and pulldir/csv exist
--print("all good, moving on")

if args[1] == "url" then --user just wants to pull from specific url
      if type(args[2]) == "nil" then
            term.setTextColor(color.userfailure)
            print("missing second arg after 'url'")
      else
            handleurl(args[2])
            term.setTextColor(color.success)
            print("done attempting pull on url")
      end

elseif args[1] == "all" then --user wants to pull from every url in pull csv
      local tempread = fs.open("pulldir/pullcsv","r")
      local csvstring = tempread.readAll()
      tempread:close()

      for value in string.gmatch(csvstring, '([^,]+),') do
            handleurl(value)
      end
      term.setTextColor(color.success)
      print("done attempting pull on every url in csv")

elseif args[1] == "add" then --user is just adding to the pull csv
      --read the csv to a string to compare input
      local tempread = fs.open("pulldir/pullcsv","r")
      local csvstring = tempread.readAll()
      tempread:close()

      if type(args[2]) == "nil" then
            term.setTextColor(color.userfailure)
            print("missing second arg after 'add'")
      else
            if not (csvstring:find(args[2])) then
                  term.setTextColor(color.operation)
                  pullcsv = io.open("pulldir/pullcsv","a")
                  pullcsv:write((args[2]..","))
                  term.setTextColor(color.success)
                  print("url added to csv")
            else
                  term.setTextColor(color.success)
                  print("not adding: supplied url found in csv")
            end
      end

elseif args[1] == "cut" then --user wants to remove one url from pull csv
      --read the csv to a string to check, modify, write
      local tempread = fs.open("pulldir/pullcsv","r")
      local csvstring = tempread.readAll()
      tempread:close()

      if type(args[2]) == "nil" then
            term.setTextColor(color.userfailure)
            print("missing second arg after 'cut'")
      else
            local startpos,endpos = csvstring:find(args[2])
            if startpos then
                  csvstring = csvstring:sub(1,startpos-1) .. csvstring:sub(endpos+1)
                  tempwriter = io.open("pulldir/pullcsv","w+")
                  tempwriter:write(csvstring)
                  term.setTextColor(color.success)
                  print("url removed from csv")
            else
                  term.setTextColor(color.success)
                  print("no match to remove")
            end
      end

else --user messed up the command on purpose or not, print the help string
      print("usage:\npull [url/all/add/cut/(empty)] [(url)]")
end

