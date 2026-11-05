#!/bin/bash -eu

System="@EPREFIX@/opt/unreal-tournament/System"
MyIni="${HOME}"/.utpg/System/UnrealTournament.ini
GameRenderDevice="@GameRenderDevice@"

lang=${LC_MESSAGES:-${LC_ALL:-${LANG:-in}}}
[[ ${lang} == en* ]] && lang=in

seds=(
	-e "/^\[Engine\.Engine\]/,/^\[/s:^Language=.*:Language=${lang:0:2}t:"
	-e "/^\[SDLDrv.SDLClient\]/,/^\[/s:^WindowingSystem=.*:WindowingSystem=SDL3_WINDOWING_SystemPreferred:"
)

[[ -n ${GameRenderDevice} ]] && seds+=(
	-e "/^\[Engine\.Engine\]/,/^\[/s:^GameRenderDevice=.*:GameRenderDevice=${GameRenderDevice}:"
)

mkdir -p "${HOME}"/.utpg/System
cp --update=none "${System}/Default.ini" "${MyIni}"
sed -i "${seds[@]}" "${MyIni}"
exec "${System}/ut-bin" "${@}"
