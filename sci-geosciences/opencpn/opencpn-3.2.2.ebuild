# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"
inherit cmake-utils wxwidgets

DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="http://opencpn.org/"
SRC_URI="https://github.com/OpenCPN/OpenCPN/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gps"

RDEPEND="
	app-arch/bzip2
	dev-libs/tinyxml
	media-libs/freetype:2
	sys-libs/zlib
	virtual/opengl
	x11-libs/gtk+:2
	x11-libs/wxGTK:2.8[X]
	gps? ( >=sci-geosciences/gpsd-2.96-r1 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext"

S="${WORKDIR}/OpenCPN-${P}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use gps GPSD)
		-DUSE_S57=ON
		-DUSE_GARMINHOST=ON
		-DUSE_WIFI_CLIENT=OFF
	)

	cmake-utils_src_configure
}
