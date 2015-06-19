# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-cdplayer/vdr-cdplayer-1.2.2.ebuild,v 1.1 2015/03/03 10:58:00 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: CD-PLAYER"
HOMEPAGE="http://www.uli-eckhardt.de/vdr/cdplayer.en.shtml"
SRC_URI="http://www.uli-eckhardt.de/vdr/download/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="cdparanoia"

DEPEND=">=media-video/vdr-2
		>=dev-libs/libcdio-0.8.0
		>=media-libs/libcddb-1.3.0
		cdparanoia? ( >=dev-libs/libcdio-paranoia-0.90 )"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	use cdparanoia || BUILD_PARAMS="NOPARANOIA=1"
}
