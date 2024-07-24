version '1.0.2'
author 'Fivemerr'
description 'FXServer logs to Fivemerr'
repository 'https://github.com/FiveMerr/fm-logs'

dependency 'screenshot-basic'

-- Server Scripts
server_script {
    'server/logger.lua',
    'server/main.lua',
    'server/events/*.lua',
    'server/framework/*lua',
    'server/exports.lua'
}

-- Client Scripts
client_script {
    'client/main.lua',
    'client/logs/*.lua',
    'client/exports.lua'
}

-- Shared scripts
shared_script {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/tables.lua',
    'shared/language.lua',
    'shared/framework.lua'
}

lua54 'yes'
game 'gta5'
fx_version 'cerulean'
