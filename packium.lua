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
  
  for o,i in pairs(repo.packages) do
      if tostring(o) == package then
          print("Installing musicify...")
          shell.run("o.install")
      else
        error("Package " .. tostring(package) ..  " not found...")
      end
  end
end

command = table.remove(args, 1)

if packium[command] then
    packium[command](args)
else
    print("Please provide a valid command. For usage, use `packium help`.")
end