--[[
todo
implement cut feature

make it so if you try to add a URL thats already in the csv then it wont let you
make it spam you less with garbage
make it use colored text

test thoroughly
]]

function handleurl(theurl)
      http.request(theurl)
      requested = true
      
      while requested do

            event, usedurl, response = os.pullEvent()
            
            if event == "http_success" then
                  
                  print("http success, file downloaded")
                  responsestring = response.readAll()
                  if usedurl:find("%.lua") then--escape the . with %, effectively if .lua is in the string then:
                        filename = usedurl:match("([^/]-)$")
                  else
                        filename = "unknown_download"
                  end
                  print("installing file with filename: "..filename)
                  tempwriter = io.open(filename,"w")
                  tempwriter:write(responsestring)
                  requested = false
            elseif event == "http_failure" then

                  print("http failure")
                  requested = false 
            end
      end
end

--capture arguments this program was run with
args = {...}

--ensure pulldir/ directory exists
if fs.exists("pulldir/") then
      print("pulldir/ exists")
else
      print("pulldir/ not found, making")
      fs.makeDir("pulldir/")
      print("pulldir/ made")
end
--at this point pulldir/ must exist, so now ensure the pulldir/pullcsv exists
if fs.exists("pulldir/pullcsv") then
      print("pulldir/pullcsv exists")
else
      print("pulldir/pullcsv not found, making")
      temp = io.open("pulldir/pullcsv","w")
      temp:close()
      print("pulldir/pullcsv made")
end
--at this point pulldir/ and pulldir/csv exist
print("all good, moving on")

if args[1] == "url" then --user just wants to pull from specific url
      if type(args[2]) == "nil" then
            print("missing second arg after 'url'")
      else
            handleurl(args[2])
      end

elseif args[1] == "all" then --user wants to pull from every url in pull csv
      local tempread = fs.open("pulldir/pullcsv","r")
      local csvstring = tempread.readAll()
      tempread:close()

      for value in string.gmatch(csvstring, '([^,]+),') do
            handleurl(value)
      end

elseif args[1] == "add" then --user is just adding to the pull csv
      if type(args[2]) == "nil" then
            print("missing second arg after 'add'")
      else
            print("adding the following to pullcsv: "..args[2]..",")    
            pullcsv = io.open("pulldir/pullcsv","a")
            pullcsv:write((args[2]..","))
      end

elseif args[1] == "cut" then --user wants to remove one url from pull csv


else --user messed up the command on purpose or not, print the help string
      print("usage:\npull [url/all/add/cut/(empty)] [(url)]")
end