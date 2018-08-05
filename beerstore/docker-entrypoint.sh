#!/bin/bash

set -eo pipefail
shopt -s nullglob

# uso: file_env VAR [DEFAULT]
#  ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (permite usar "$XYZ_DB_PASSWORD_FILE" para setar o valor de
#  "$XYZ_DB_PASSWORD" vindo de um arquivo, para usarmos o Secret do Docker Swarm)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"

	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi

	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env 'SPRING_DATASOURCE_URL'
file_env 'SPRING_DATASOURCE_USERNAME'
file_env 'SPRING_DATASOURCE_PASSWORD'

exec /usr/bin/java -jar "$@"
