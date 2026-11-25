#!/bin/bash

set -euo pipefail

Unreal="@EPREFIX@/opt/unreal"
MyUnreal="${HOME}/.Unreal"
MyIni="${MyUnreal}/System/UnrealLinux.ini"
MyUserIni="${MyUnreal}/System/User.ini"
System="${Unreal}/@System@"

mkdir -p "${MyUnreal}"/System
cp --update=none "${System}"/DefaultLinux.ini "${MyIni}"

# XOpenGLDrv.XOpenGLRenderDevice seems broken on arm64.
# https://github.com/OldUnreal/Unreal-testing/issues/442
[[ "@System@" == SystemARM64 ]] &&
	sed -i "/^\[Engine\.Engine\]/,/^\[/s:^GameRenderDevice=.*:GameRenderDevice=OpenGLDrv.OpenGLRenderDevice:" "${MyIni}"

lang=${LC_MESSAGES:-${LC_ALL:-${LANG:-in}}}
[[ ${lang} == en* ]] && lang=in
sed -i "/^\[Engine\.Engine\]/,/^\[/s:^Language=.*:Language=${lang:0:2}t:" "${MyIni}"

# Allow the game to be used system-wide from an unwritable location. Note that
# saves do not load unless SavePath is relative for some reason.
# https://github.com/OldUnreal/Unreal-testing/issues/455
sed -i -e "/^;AddedByGentoo=/{N;d}" -e "/^\[Core\.System\]/,/^\[/{
	s:^\(Cache\|Save\)Path=.*:\1Path=$(realpath --relative-to="${System}" "${MyUnreal}")/\1:
	s:^\(Lang\)\?Paths=\.\./\(.*\):;AddedByGentoo=\n\1Paths=${MyUnreal}/\2\n\0:
}" "${MyIni}"

exe=${0##*/}
exe=${exe#unreal-}
exec "${System}/${exe}-bin" "${@}" -ini="${MyIni}" -userini="${MyUserIni}"
