#!/bin/sh
printf '\033c\033]0;%s\a' Carta Abierta
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Carta Abierta.x86_64" "$@"
