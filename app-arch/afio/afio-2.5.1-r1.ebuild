# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="cpio-format archives"
HOMEPAGE="http://members.chello.nl/k.holtman/afio.html"
SRC_URI="http://members.chello.nl/k.holtman/${P}.tgz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

PATCHES=( "${FILESDIR}"/Makefile-r1.patch )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc ANNOUNCE-* HISTORY README SCRIPTS

	local i
	for i in {1..4}; do
		docinto "script$i"
		dodoc "script$i"/*
	done
}
