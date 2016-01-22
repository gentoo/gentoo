# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="A BBS client for Linux"
HOMEPAGE="http://qterm.sourceforge.net"
SRC_URI="mirror://sourceforge/qterm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libressl"

RDEPEND="
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtdbus-4.5:4
	>=dev-qt/qtgui-4.5:4[qt3support]
	>=dev-qt/qtscript-4.5:4
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	kde-base/kdelibs
	dev-qt/qthelp:4
	dev-qt/qtwebkit:4"

PATCHES=(
	"${FILESDIR}/${PN}-0.5.11-gentoo.patch"
	"${FILESDIR}/${P}-qt4.patch"
	"${FILESDIR}/${P}-glibc216.patch"
	"${FILESDIR}/${P}-duplicatetarget.patch"
	"${FILESDIR}/${P}-qtbindir.patch"
)

src_install() {
	cmake-utils_src_install
	mv "${D}"/usr/bin/qterm "${D}"/usr/bin/QTerm || die
	dodoc README TODO
}
