#!@GENTOO_PORTAGE_EPREFIX@/bin/bash

set -euo pipefail
IFS=$'\n\t'

main() {
	local j8 j11 jcmd
	j8="$(java-config --select-vm openjdk-8 -J 2> /dev/null || true)"
	j11="$(java-config --select-vm openjdk-11 -J 2> /dev/null || true)"

	if [[ -f "$(dirname "${j8:-/}")/../jre/lib/javafx.properties" ]]; then
		jcmd="${j8}"
	elif [[ -f "$(dirname "${j11:-/}")/../lib/javafx.properties" ]]; then
		jcmd="${j11}"
	elif [[ -f @GENTOO_PORTAGE_EPREFIX@/usr/lib64/openjdk-11/lib/javafx.properties ]]; then
		jcmd="@GENTOO_PORTAGE_EPREFIX@/usr/lib64/openjdk-11/bin/java"
	elif [[ -f @GENTOO_PORTAGE_EPREFIX@/usr/lib/openjdk-11/lib/javafx.properties ]]; then
		jcmd="@GENTOO_PORTAGE_EPREFIX@/usr/lib/openjdk-11/bin/java"
	else
		echo "dev-java/openjdk[javafx] not found!" 1>&2
		exit 1
	fi

	if [[ ! -x "${jcmd}" ]]; then
		echo "${jcmd} not executable!" 1>&2
		exit 1
	fi

	env JAVACMD="${jcmd}" "@GENTOO_PORTAGE_EPREFIX@/opt/geogebra/geogebra" "${@}"
}

main "$@"
