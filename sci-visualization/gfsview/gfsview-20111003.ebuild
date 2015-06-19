# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/gfsview/gfsview-20111003.ebuild,v 1.3 2012/05/04 08:07:00 jdhore Exp $

EAPI=4

DESCRIPTION="Graphical viewer for Gerris simulation files"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=sci-libs/gerris-${PV}
	media-libs/ftgl
	media-libs/mesa[osmesa]
	x11-libs/gtk+:2
	>=x11-libs/gtkglext-1.0.6
	x11-libs/startup-notification"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${P/-20/-snapshot-}

src_configure() {
	econf $(use_enable static-libs static)
}
