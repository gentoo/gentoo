# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/coldfire/coldfire-0.3.1.ebuild,v 1.2 2010/10/10 04:44:06 vapier Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Motorola Coldfire Emulator"
HOMEPAGE="http://www.slicer.ca/coldfire/"
SRC_URI="http://www.slicer.ca/coldfire/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sys-libs/ncurses
	sys-libs/readline"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-headers.patch
}

src_install() {
	dodir /usr/bin
	einstall || die
	dodoc CONTRIBUTORS HACKING README
}
