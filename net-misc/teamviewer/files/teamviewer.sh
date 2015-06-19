#!/bin/bash

tv="$(basename $0)"
version="@TVV@"
tvw_version=""
prefix="${HOME}/.wine-${tv}"
arch="win32"
native=true

if [ ! -d "${prefix}" ]; then
	echo "Creating prefix..."
	env WINEARCH="${arch}" WINEPREFIX="${prefix}" wineboot -i &> /dev/null
fi

if [ -e "${prefix}/tvw-version" ]; then
	tvw_version=$(<"${prefix}/tvw-version")
fi

#If version has changed or new instance
if [ "${version}" != "${tvw_version}" ]; then
	echo "Copying TeamViewer files to prefix..."
	cp -R "/opt/${tv}/wine/drive_c/TeamViewer" "${prefix}/drive_c/TeamViewer"
	echo "Creating config and log directories in ~/.config/teamviewer@TVMV@"
	mkdir -p "${HOME}"/.config/teamviewer@TVMV@/{config,logfiles}
	echo "${version}" > "${prefix}/tvw-version"
fi

TV_BASE_DIR="${tv}"
TV_BIN_DIR="${TV_BASE_DIR}/tv_bin"
TV_PROFILE="${prefix}"
TV_LOG_DIR="${TV_PROFILE}/logfiles"
TV_CFG_DIR="${TV_PROFILE}/config"
TV_USERHOME="${HOME}"

if $native; then
	export WINEDLLPATH="${prefix}/drive_c/TeamViewer"
else
	export WINEDLLPATH="${tv}/tv_bin/wine/lib:${tv}/tv_bin/wine/lib/wine:${prefix}/drive_c/TeamViewer"
	export PATH="${tv}/tv_bin/wine/bin:${PATH}"
fi
export WINEPREFIX="${prefix}"
wine "C:\\TeamViewer\\TeamViewer.exe" "\${[@]}" &> \
	"${HOME}/.config/teamviewer@TVMV@/logfiles/$(date +%Y.%m.%d-%H:%M:%S)-wine.log"
