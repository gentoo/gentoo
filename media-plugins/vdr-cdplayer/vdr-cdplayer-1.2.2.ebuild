# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: CD-PLAYER"
HOMEPAGE="https://www.uli-eckhardt.de/vdr/cdplayer.en.shtml"
SRC_URI="https://www.uli-eckhardt.de/vdr/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdparanoia"

DEPEND="media-video/vdr
	dev-libs/libcdio
	media-libs/libcddb
	cdparanoia? ( dev-libs/libcdio-paranoia )"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	use cdparanoia || BUILD_PARAMS="NOPARANOIA=1"
}
