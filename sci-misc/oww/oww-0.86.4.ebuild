# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/oww/oww-0.86.4.ebuild,v 1.1 2013/10/08 14:29:10 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="A one-wire weather station for Dallas Semiconductor"
HOMEPAGE="http://oww.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls usb"

RDEPEND="
	net-misc/curl
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	)

src_configure() {
	local myeconfargs=(
		--enable-interactive
		$(use_enable nls)
		$(use_enable gtk gui)
		$(use_with usb)
	)
	autotools-utils_src_configure
}
