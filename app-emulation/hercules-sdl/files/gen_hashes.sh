#!/usr/bin/env bash

[[ -z "${1}" ]] && exit 1
[[ "${1}" =~ [0-9]+\.[0-9]+\.[0-9]+ ]] || exit 1

CLONEDIR="$(mktemp -d)"
for f in "hyperion" "crypto" "decNumber" "SoftFloat" "telnet"
do
    git -C "${CLONEDIR}" clone --tags "https://github.com/SDL-Hercules-390/${f}"
done

VERSIONARR=( ${1//./ })
VERSIONTAG="Release_${VERSIONARR[0]}.${VERSIONARR[1]}"
[[ "${VERSIONARR[2]}" == "0" ]] || VERSIONTAG+=".${VERSIONARR[2]}"
RELEASEDATE="$(git -C "${CLONEDIR}/hyperion" show -s --format="%ci" "${VERSIONTAG}")"

echo
for f in "crypto" "decNumber" "SoftFloat" "telnet"
do
    echo -n "${f,,}: "
    git -C "${CLONEDIR}/${f}" rev-list -n 1 --first-parent --before="${RELEASEDATE}" master
done

rm -rf "${CLONEDIR}"
