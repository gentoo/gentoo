# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

MY_P="${PN}-S${PV}"
DESCRIPTION="fixed point cd ripper"
HOMEPAGE="http://vertigo.fme.vutbr.cz/~stibor/dagrab.html"
SRC_URI="http://ashtray.jz.gts.cz/~smsti/archiv/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-freedb.patch"
)

src_prepare() {
	# fix #570732 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	default
}

src_install() {
	dobin dagrab
	dodoc BUGS CHANGES FAQ grab TODO
	doman dagrab.1
}
