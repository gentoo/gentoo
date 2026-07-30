#!/bin/bash -eu

System="@EPREFIX@/opt/unreal-tournament/@System@"
MyIni="${HOME}"/.utpg/System/UnrealTournament.ini
GameRenderDevice="@GameRenderDevice@"

mkdir -p "${HOME}"/.utpg/System
cp --update=none "${System}/Default.ini" "${MyIni}"

[[ -n ${GameRenderDevice} ]] &&
	sed -i "/^\[Engine\.Engine\]/,/^\[/s:^GameRenderDevice=.*:GameRenderDevice=${GameRenderDevice}:" "${MyIni}"

lang=${LC_MESSAGES:-${LC_ALL:-${LANG:-in}}}
[[ ${lang} == en* ]] && lang=in
sed -i "/^\[Engine\.Engine\]/,/^\[/s:^Language=.*:Language=${lang:0:2}t:" "${MyIni}"

exe=${0##*/}
exe=${exe#unreal-tournament}
exe=${exe#-}
exec "${System}/${exe:-ut}-bin" "${@}"
