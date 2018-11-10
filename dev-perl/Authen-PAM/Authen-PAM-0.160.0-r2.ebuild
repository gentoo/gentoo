# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NIKIP
DIST_VERSION=0.16
DIST_EXAMPLES=("test.pl")
inherit perl-module

DESCRIPTION="Interface to PAM library"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="examples"

RDEPEND="virtual/pam"
DEPEND="${RDEPEND}"
PATCHES=("${FILESDIR}/no-dot-inc.patch")
export OPTIMIZE="$CFLAGS"

src_test() {
	local MODULES=(
		"Authen::PAM ${DIST_VERSION}"
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
	ewarn "To comprehensively test this module, interactive testing is necessary"
	ewarn "For details, see:"
	ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Authen-PAM"
}
