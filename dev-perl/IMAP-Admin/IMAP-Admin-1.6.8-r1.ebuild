# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EESTABROO
DIST_EXAMPLES=("examples/*" "test.pl")
DIST_WIKI=tests
inherit perl-module

DESCRIPTION="Perl module for basic IMAP server administration"

SLOT="0"
KEYWORDS="amd64 x86"

src_test() {
	local MODULES=(
		"IMAP::Admin ${DIST_VERSION}"
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
}
