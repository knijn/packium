-- Grabbing the repo file and storing it into a variable
local handle = fs.open("./config.json", "r")
local config = handle.read()
handle.close()

-- Store the repo into a variable to read from
local repoURL = "https://raw.githubusercontent.com/knijn/packium/main/repo/stable.json?cb=" .. os.epoch("utc")
local handle = http.get(repoURL)
local repoJSON = handle.readAll()
handle.close()
local repo, err = textutils.unserialiseJSON(repoJSON)

-- Show an error if repo failed
if not repo then
    error("The repo is malformed.")
    if err then error(err) end
    return
end

-- Other variable nonsense
local packium = {}
local args = {...}

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
 


packium.help = function (arguments)
    print([[
Usage: <action> [arguments]
Actions:
packium
    help       -- Displays this message
    info       -- Displays information about a package
    install    -- Installs the specified package
    remove     -- Removes the specified package
    list       -- Searches for packages including keywords
]])
end

packium.install = function (arguments)
  local package = arguments[1]
    if not package or not tostring(package) then
    error("Please specify a package to be installed.")
  end
  
  print("Locating " .. package .. "...")
  if not repo.packages[package] then -- Thanks 6_4 for helping with this!!
    error("Package " .. tostring(package) ..  " not found...")
  end
  local i = repo.packages[package]
  print("Installing " .. package .. "...")

  for o,i in pairs(i.depends) do
      shell.run()
  end

  shell.run("wget run " .. i.installurl) -- Thanks 6_4 for helping with this!!
end


packium.info = function (arguments)
  local package = arguments[1]
    if not package or not tostring(package) then
    error("Please specify a package to get info.")
    end
  
  print("Locating " .. package .. "...")
  if not i == repo.packages[package] then -- Thanks 6_4 for helping with this!!
    error("Package " .. tostring(package) ..  " not found...")
  end
  local i = repo.packages[package]

        print(package .. " info:")
        print(tostring(dump(i)))
        
        --print("Name: " .. i.name)
        --print("Author: " .. i.author)
        --print("Branch: " .. directpackage.branch)
        print("Version: " .. i.ver)
        if #directpackage.depends > 0 then
          print("Dependencies:")
          for _, dep in pairs(directpackage.depends) do
            print(" " .. dep.package .. " - minimum version: " .. dep.version)
          end
        end
end

command = table.remove(args, 1)

if packium[command] then
    packium[command](args)
else
    print("Please provide a valid command. For usage, use `packium help`.")
end