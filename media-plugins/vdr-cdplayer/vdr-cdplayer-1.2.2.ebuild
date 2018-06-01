# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: CD-PLAYER"
HOMEPAGE="https://www.uli-eckhardt.de/vdr/cdplayer.en.shtml"
SRC_URI="https://www.uli-eckhardt.de/vdr/download/${P}.tgz"

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
