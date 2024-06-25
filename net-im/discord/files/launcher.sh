#!/bin/env bash
# coding: UTF-8


declare -a discord_parameters

SECCOMP=false

[[ ! "${SECCOMP}" ]] && discord_parameters+=( --disable-seccomp-filter-sandbox )

[[ -n "${WAYLAND_DISPLAY}" ]] && discord_parameters+=(
	--enable-features=UseOzonePlatform
	--ozone-platform=wayland
	--enable-wayland-ime
)

@@DESTDIR@@/Discord "${discord_parameters[@]}" "$@"
