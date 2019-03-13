# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ABLUM
DIST_VERSION=0.5
inherit perl-module

DESCRIPTION="Queries multiple Realtime Blackhole Lists in parallel"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/perl-Time-HiRes
	dev-perl/Net-DNS"

S=${WORKDIR}/RBLCLient-${DIST_VERSION} # second capitialized 'l' is deliberate

src_test() {
	local MODULES=(
		"Net::RBLClient 0.4"
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
