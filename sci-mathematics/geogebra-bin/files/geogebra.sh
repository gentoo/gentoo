#!@GENTOO_PORTAGE_EPREFIX@/bin/bash

main() {
	local JAVACMD
	# prefer openjdk-8 over 11
	local j8="$(java-config --select-vm openjdk-8 -J)"
	local j11="$(java-config --select-vm openjdk-11 -J)"

	if [[ -f $(dirname ${j8:-/})/../jre/lib/javafx.properties ]]; then
		JAVACMD="${j8}"
	elif [[ -f $(dirname ${j11:-/})/../lib/javafx.properties ]]; then
		JAVACMD="${j11}"
	else
		echo "openjdk[javafx] not found!"  1>&2
		exit 1
	fi

	echo "using ${JAVACMD}"
	export JAVACMD
	exec "@GENTOO_PORTAGE_EPREFIX@/opt/geogebra/geogebra" "${@}"
}

main "$@"
