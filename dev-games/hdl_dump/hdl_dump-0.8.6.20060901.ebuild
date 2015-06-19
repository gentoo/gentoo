# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/hdl_dump/hdl_dump-0.8.6.20060901.ebuild,v 1.7 2015/04/06 09:42:05 tupone Exp $

EAPI=5
inherit eutils toolchain-funcs versionator

MY_PV=$(replace_version_separator 3 -)
DESCRIPTION="game installer for playstation 2 HD Loader"
HOMEPAGE="http://www.psx-scene.com/hdldump/"
SRC_URI="http://www.psx-scene.com/hdldump/hdl_dumx-${MY_PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-fortify.patch #340145
	sed -i \
		-e "s/-O0 -g/${CFLAGS}/" \
		-e "s/@\$(CC)/$(tc-getCC)/" \
		-e '/LDFLAGS =/d' \
		Makefile || die
}

src_install() {
	dobin hdl_dump
	dodoc AUTHORS CHANGELOG README TODO
}
