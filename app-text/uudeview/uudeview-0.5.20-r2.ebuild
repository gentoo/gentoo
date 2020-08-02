# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="uu, xx, base64, binhex decoder"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${P}-bugfixes.patch
	"${FILESDIR}"/${P}-CVE-2004-2265.patch
	"${FILESDIR}"/${P}-CVE-2008-2266.patch
	"${FILESDIR}"/${P}-man.patch
	"${FILESDIR}"/${P}-rename.patch
	"${FILESDIR}"/${P}-makefile.patch
)

DOCS=( HISTORY INSTALL README )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-tcl \
		--disable-tk
}
