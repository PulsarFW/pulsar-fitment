fx_version 'cerulean'
games { 'gta5' }

name 'Pulsar Fitment'
description 'Wheel fitment with camber and offset adjustment'
author 'Artmines - maintained for Pulsar Framework'
url 'https://pulsarframe.work'
version 'v1.0.0'

version_check 'yes'
github 'https://github.com/PulsarFW/pulsar_fitment'

client_script '@pulsar_core/components/cl_error.lua'
shared_script '@pulsar_core/core/sh_pulsar.lua'
client_script '@pulsar_pwnzor/client/check.lua'

client_scripts({
	'client/**/*.lua',
})

server_scripts({
	'server/**/*.lua',
})

lua54 'yes'