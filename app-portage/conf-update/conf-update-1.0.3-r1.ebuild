# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="${PN} is a ncurses-based config management utility"
HOMEPAGE="https://gitweb.gentoo.org/proj/conf-update.git/"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="colordiff libressl"

RDEPEND=">=dev-libs/glib-2.6
		sys-libs/ncurses:0
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
		colordiff? ( app-misc/colordiff )"
DEPEND="virtual/pkgconfig
		${RDEPEND}"

src_prepare() {
	sed -i -e "s/\$Rev:.*\\$/${PVR}/" "${S}"/"${PN}".h || die
	if use colordiff ; then
		sed -i -e "s/diff_tool=diff/diff_tool=colordiff/" ${PN}.conf  \ die 'colordiff-sed failed'
	fi
	tc-export PKG_CONFIG
}

src_compile() {
	emake CC="$(tc-getCC)"
}
