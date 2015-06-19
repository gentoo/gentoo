# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmsg/wmmsg-1.0.1-r1.ebuild,v 1.6 2014/04/07 19:32:30 ssuominen Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="a dockapp that informs events, such as incoming chat messages, by displaying icons and times"
HOMEPAGE="http://swapspace.net/~matt/wmmsg"
SRC_URI="http://swapspace.net/~matt/wmmsg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	media-libs/imlib2
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-libs/libXt"

DOCS="AUTHORS ChangeLog README wmmsgrc"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-use_gtk2.patch \
		"${FILESDIR}"/${P}-alt-desktop.patch

	eautoreconf
}
