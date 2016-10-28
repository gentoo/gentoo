# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Utility to convert raster images to EPS, PDF and many others"
HOMEPAGE="https://github.com/pts/sam2p"
SRC_URI="https://github.com/pts/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="examples gif"

DEPEND="dev-lang/perl"

RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-build-fixes.patch )

src_prepare() {
	default

	# configure.in files are deprecated
	mv configure.{in,ac} || die

	# eautoreconf is still needed or you get bad warnings
	eautoreconf
}

src_configure() {
	tc-export CXX

	econf --enable-lzw $(use_enable gif)
}

src_install() {
	dobin sam2p
	einstalldocs

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
