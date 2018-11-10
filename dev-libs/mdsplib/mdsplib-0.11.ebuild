# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="METAR Decoder Software Package Library"
HOMEPAGE="http://limulus.net/mdsplib/"
SRC_URI="http://limulus.net/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	tc-export AR CC RANLIB
}

src_compile() {
	emake all
}

src_install() {
	dobin dmetar
	doheader metar.h
	dolib.a libmetar.a
	einstalldocs
}
