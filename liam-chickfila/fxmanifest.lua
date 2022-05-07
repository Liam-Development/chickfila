fx_version 'cerulean'
author 'Liam'
game 'gta5'
lua54 'yes'
escrow_ignore 'config.lua'
escrow_ignore 'en.lua'

description 'Chick Fil A Job'

version '1.3.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/en.lua',
	'config.lua',
	'client.lua'
}

dependencies {
	'es_extended'
}
