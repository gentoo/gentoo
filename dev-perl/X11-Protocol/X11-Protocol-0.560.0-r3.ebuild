# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SMCCAM
DIST_VERSION=0.56
DIST_EXAMPLES=("eg/*")
inherit perl-module virtualx

DESCRIPTION="Client-side interface to the X11 Protocol"

LICENSE="${LICENSE} MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	x11-libs/libXrender
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${RDEPEND}
	test? ( media-fonts/font-misc-misc )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.56-test-timeout.patch"
	"${FILESDIR}/${PN}-0.56-test-tap.patch"
)

src_test() {
	virtx perl-module_src_test
}
