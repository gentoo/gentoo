# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HARDAKER
DIST_VERSION=0.93
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Auto-GUI extending Getopt::Long"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="virtual/perl-File-Temp
	virtual/perl-Getopt-Long"

src_test() {
	local MODULES=(
		"Getopt::GUI::Long ${DIST_VERSION}"
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
