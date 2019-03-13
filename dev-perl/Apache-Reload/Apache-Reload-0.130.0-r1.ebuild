# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHAY
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Automatically reload changed modules without restarting Apache"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 x86"
IUSE=""

RDEPEND="www-apache/mod_perl"
DEPEND="${RDEPEND}
	dev-perl/Apache-Test
"

src_test() {
	local MODULES=(
		"Apache::Reload ${DIST_VERSION}"
		"Apache2::Reload ${DIST_VERSION}"
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
