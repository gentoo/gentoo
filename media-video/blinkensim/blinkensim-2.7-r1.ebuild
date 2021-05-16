# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="Graphical Blinkenlights simulator with networking support"

HOMEPAGE="http://blinkenlights.net/project/developer-tools"
SRC_URI="http://blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aalib gtk"

# if the config script finds any of the optional library it will try to
# compile against it
RDEPEND="
	>=media-libs/blib-1.1.4
	media-video/blinkenthemes
	aalib? ( >=media-libs/aalib-1.4_rc4-r2 )
	gtk? ( >=x11-libs/gtk+-2.4.4:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
