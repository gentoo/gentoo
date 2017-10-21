# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALIAN
DIST_VERSION=3.2
inherit perl-module autotools

DESCRIPTION="Provide Perl API for libsmbclient.so"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=net-fs/samba-4.2[client]"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-pkg_config.patch"
	"${FILESDIR}/${P}-close_fn.patch"
)

src_prepare() {
	perl-module_src_prepare
	eautoreconf
}
src_test() {
	local MODULES=(
		"Filesys::SmbClient ${DIST_VERSION}"
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
	# standard tests are not designed to work on a non-developer system.
}
