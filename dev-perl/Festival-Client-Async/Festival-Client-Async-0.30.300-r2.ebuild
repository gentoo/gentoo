# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DJHD
DIST_VERSION=0.0303
inherit perl-module

DESCRIPTION="Non-blocking interface to a Festival server"

SLOT="0"
KEYWORDS="~amd64 ia64 sparc x86"
IUSE=""

src_test() {
	local MODULES=(
		"Festival::Client::Async ${DIST_VERSION}"
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
	ewarn "Comprehensive testing may require manual steps. For details, see:"
	ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Festival-Client-Async"
	perl-module_src_test
}
