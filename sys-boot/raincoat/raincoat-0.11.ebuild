# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

DESCRIPTION="Flash the Xbox boot chip"
HOMEPAGE="https://sourceforge.net/projects/xbox-linux/"
SRC_URI="https://sourceforge.net/projects/xbox-linux/files/Other/Raincoat/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	dodir /etc /usr/bin
	emake install DESTDIR="${D}" || die
	dodoc docs/README
}
