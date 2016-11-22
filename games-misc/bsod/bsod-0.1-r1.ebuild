# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="This program will let your UNIX user experience the authentic Microsoft Windows experience"
HOMEPAGE="http://www.vanheusden.com/bsod/"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:0"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_prepare() {
	default
	tc-export PKG_CONFIG
}

src_install() {
	dobin ${PN}
	dodoc Changes
}
