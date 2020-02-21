# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SMCCAM
DIST_VERSION=0.56
DIST_EXAMPLES=("eg/*")
inherit perl-module virtualx

DESCRIPTION="Client-side interface to the X11 Protocol"

LICENSE="${LICENSE} MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libXext"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.56-test-timeout.patch"
	"${FILESDIR}/${PN}-0.56-test-tap.patch"
)
src_test() {
	virtx perl-module_src_test
}
