# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg prefix

DESCRIPTION="GRaph Algorithms using PErmutation groups"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2+"
KEYWORDS="~amd64"
IUSE="bliss"

RDEPEND="bliss? ( sci-libs/bliss )
	!bliss? ( sci-mathematics/nauty )"

PATCHES=( "${FILESDIR}/${PN}-4.9.0-exec.patch" )

DOCS=( README.md CHANGES.md )

GAP_PKG_HTML_DOCDIR="htm"
GAP_PKG_EXTRA_INSTALL=( grh )
gap-pkg_enable_tests

src_prepare() {
	# The ./configure script and Makefile are only used to build
	# the "dreadnaut" executable that we don't want anyway (we
	# use the system copy; see $PATCHES).
	rm -r nauty2_8_6 || die
	rm configure Makefile.in || die

	default

	local nauty="true"
	use bliss && nauty="false"

	sed -i "s:@nauty@:${nauty}:" lib/grape.g || die
	eprefixify lib/grape.g
}
