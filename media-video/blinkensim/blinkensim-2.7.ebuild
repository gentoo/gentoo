# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/blinkensim/blinkensim-2.7.ebuild,v 1.9 2012/05/05 08:58:57 jdhore Exp $

DESCRIPTION="Graphical Blinkenlights simulator with networking support"

HOMEPAGE="http://www.blinkenlights.net/project/developer-tools"
SRC_URI="http://www.blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="aalib gtk directfb"

# if the config script finds any of the optional library it will try to
# compile against it
DEPEND=">=media-libs/blib-1.1.4
	virtual/pkgconfig
	aalib? ( >=media-libs/aalib-1.4_rc4-r2 )
	gtk? ( >=x11-libs/gtk+-2.4.4 )
	directfb? ( >=dev-libs/DirectFB-0.9.20-r1 )"
RDEPEND="media-video/blinkenthemes"

src_install() {
	make DESTDIR="${D}" \
		install || die "install failed"
}
