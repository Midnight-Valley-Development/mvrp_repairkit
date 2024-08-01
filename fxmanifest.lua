fx_version 'cerulean'
game 'gta5'
lua54 'yes' 
use_experimental_fxv2_oal 'yes'

author 'Midnight Valley Development'
description 'Advanced Repair Kit'
version '1.0.1'


files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'locales/*.lua',
    'shared/functions.lua',
    'config/config.lua',
}

client_scripts {
    'framework/**/client.lua',
    'client/*.lua'
}

server_scripts {
    'framework/**/server.lua',
    'server/*.lua'
}
