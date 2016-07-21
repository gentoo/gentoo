# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="makes cpio-format archives and deals somewhat gracefully with input data corruption"
HOMEPAGE="http://members.chello.nl/k.holtman/afio.html"
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
