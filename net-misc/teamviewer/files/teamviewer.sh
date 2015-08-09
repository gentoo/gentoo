#!/bin/bash

tv="$(basename $0)"
tvdir="/opt/${tv}"
version="@TVV@"
tvw_version=""
prefix="${HOME}/.wine-${tv}"
arch="win32"
native=true

if $native; then
	export WINEDLLPATH="${prefix}/drive_c/TeamViewer"
else
	export WINEDLLPATH="${tvdir}/tv_bin/wine/lib:${tvdir}/tv_bin/wine/lib/wine:${prefix}/drive_c/TeamViewer"
	export PATH="${tvdir}/tv_bin/wine/bin:${PATH}"
fi
export WINEARCH="${arch}"
export WINEPREFIX="${prefix}"

if [ ! -d "${prefix}" ]; then
	echo "Creating prefix..."
	wineboot -i &> /dev/null
	mkdir -p "${prefix}/drive_c/TeamViewer"
fi

if [ -e "${prefix}/tvw-version" ]; then
	tvw_version=$(<"${prefix}/tvw-version")
fi

#If version has changed or new instance
if [ "${version}" != "${tvw_version}" ]; then
	echo "Copying TeamViewer files to prefix..."
	cp -R "/opt/${tv}/wine/drive_c/TeamViewer" "${prefix}/drive_c/"
	echo "Creating config and log directories in ~/.config/teamviewer@TVMV@"
	mkdir -p "${HOME}"/.config/teamviewer@TVMV@/{config,logfiles}
	echo "${version}" > "${prefix}/tvw-version"
fi

TV_BASE_DIR="${tvdir}"
TV_BIN_DIR="${TV_BASE_DIR}/tv_bin"
TV_PROFILE="${prefix}"
TV_LOG_DIR="${TV_PROFILE}/logfiles"
TV_CFG_DIR="${TV_PROFILE}/config"
TV_USERHOME="${HOME}"

wine "C:\\TeamViewer\\TeamViewer.exe" "\${[@]}" &> \
	"${HOME}/.config/teamviewer@TVMV@/logfiles/$(date +%Y.%m.%d-%H:%M:%S)-wine.log"
