# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Afio creates cpio-format archives."
HOMEPAGE="http://members.chello.nl/k.holtman/afio.html https://github.com/kholtman/afio"
SRC_URI="http://members.chello.nl/k.holtman/${P}.tgz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/Makefile-r1.patch
	tc-export CC
}

src_install() {
	local i
	dobin afio
	dodoc ANNOUNCE-* HISTORY README SCRIPTS
	for i in 1 2 3 4; do
		docinto script$i
		dodoc script$i/*
	done
	doman afio.1
}
