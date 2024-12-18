#!/usr/bin/env bash
# coding: UTF-8


declare -a discord_parameters

# Variables set during ebuild configuration
EBUILD_SECCOMP=false
EBUILD_WAYLAND=false

"${EBUILD_SECCOMP}" || discord_parameters+=( --disable-seccomp-filter-sandbox )

"${EBUILD_WAYLAND}" && \
[[ -n "${WAYLAND_DISPLAY}" ]] && discord_parameters+=(
	--enable-features=UseOzonePlatform
	--ozone-platform=wayland
	--enable-wayland-ime
	--disable-gpu-memory-buffer-video-frames
)

@@DESTDIR@@/Discord "${discord_parameters[@]}" "$@"
