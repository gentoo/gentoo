# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/baka-mplayer/baka-mplayer-2.0.2.ebuild,v 1.2 2015/03/09 11:31:03 yngwin Exp $

EAPI=5
inherit qmake-utils

DESCRIPTION="Cross-platform libmpv-based multimedia player with uncluttered design"
HOMEPAGE="http://bakamplayer.u8sand.net/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-video/mpv[libmpv]
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/Baka-MPlayer-${PV}"

src_prepare() {
	# no need to install license
	sed -e '/^INSTALLS/s:license::' -i src/Baka-MPlayer.pro || die
	# put manual in our docdir
	sed -e '/^manual.path/s:yer:yer-'${PV}':' -i src/Baka-MPlayer.pro || die
}

src_configure() {
	eqmake5 INSTROOT="${D}" CONFIG+=install_translations src/Baka-MPlayer.pro
}
