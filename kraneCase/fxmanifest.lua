--[[
    Thank you for purchasing.
    Feel free to request support directly from me at: krane#2890 on discord.
]]
fx_version "cerulean"
lua54 'yes'
game "gta5"
dependency "vrp"

escrow_ignore {
    "classes/c_config.lua",
    "s_config.lua",
}

client_scripts {
    "@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"@vrp/lib/utils.lua",
    "classes/*.lua",
    "c_*.lua",
}


server_scripts {
    "@vrp/lib/utils.lua",
    "s_*.lua",
}