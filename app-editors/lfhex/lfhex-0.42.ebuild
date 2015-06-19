# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/lfhex/lfhex-0.42.ebuild,v 1.9 2013/03/02 19:21:33 hwoarang Exp $

EAPI=4
inherit eutils qt4-r2

DESCRIPTION="A fast, efficient hex-editor with support for large files and comparing binary files"
HOMEPAGE="http://stoopidsimple.com/lfhex"
SRC_URI="http://stoopidsimple.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4
	x11-libs/libXt"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

S=${WORKDIR}/${P}/src

src_prepare() {
	# Apply Debian patches to fix compilation errors like gcc-4.7 compat
	epatch "${FILESDIR}"/*.dpatch
}

src_configure() {
	eqmake4
}

src_install() {
	dobin lfhex
	dodoc ../README
	make_desktop_entry "${PN}" "${PN}"
}
