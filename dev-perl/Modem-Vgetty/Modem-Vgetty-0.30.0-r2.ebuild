# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=YENYA
DIST_VERSION=0.03
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Interface to voice modems using vgetty"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

src_test() {
	local MODULES=(
		"Modem::Vgetty ${DIST_VERSION}"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	perl-module_src_test
}
