#!/bin/bash -eu

System="@EPREFIX@/opt/ut2004/@System@"

mkdir -p "${HOME}"/.ut2004/System
cp --update=none "${System}/Default.ini" "${HOME}"/.ut2004/System/UT2004.ini

lang=${LC_MESSAGES:-${LC_ALL:-${LANG:-in}}}
[[ ${lang} == en* ]] && lang=in
sed -i "/^\[Engine\.Engine\]/,/^\[/s:^Language=.*:Language=${lang:0:2}t:" "${HOME}"/.ut2004/System/UT2004.ini

exe=${0##*/}
exe=${exe#ut2004-}
exe=${exe@U}
exec "${System}/${exe}" "${@}"
