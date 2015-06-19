# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/clockywock/clockywock-0.3.1a.ebuild,v 1.3 2013/04/04 19:47:07 ago Exp $

EAPI="5"

inherit base toolchain-funcs

DESCRIPTION="ncurses based analog clock"
HOMEPAGE="http://soomka.com/clockywock"
SRC_URI="http://soomka.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_prepare() {
	# Respect compiler
	tc-export CXX

	base_src_prepare
}

src_install() {
	dobin ${PN}
	doman ${PN}.7
	dodoc README CREDITS
}
