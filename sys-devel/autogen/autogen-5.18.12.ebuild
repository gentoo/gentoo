# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Program and text file generation"
HOMEPAGE="https://www.gnu.org/software/autogen/"
SRC_URI="mirror://gnu/${PN}/rel${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="libopts static-libs"

# This should be guile-1.8+, but upstream has a bug with older versions:
# https://savannah.gnu.org/support/index.php?109051
RDEPEND=">=dev-scheme/guile-2.0:=
	dev-libs/libxml2"
DEPEND="${RDEPEND}"

src_prepare() {
	# https://savannah.gnu.org/support/index.php?109050
	sed -i \
		-e "/--cflags-only-I/s:pkg-config:$(tc-getPKG_CONFIG):" \
		configure || die
}

src_configure() {
	# suppress possibly incorrect -R flag
	export ag_cv_test_ldflags=

	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	if ! use libopts ; then
		rm "${ED}"/usr/share/autogen/libopts-*.tar.gz || die
	fi
}
