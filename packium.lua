-- Grabbing the config file and storing it into a variable
local indexURL = "https://raw.githubusercontent.com/RubenHetKonijn/computronics-songs/main/index.json?cb=" .. os.epoch("utc")
local handle = fs.open("./config.json", r)
local config = handle.read()
handle.close()