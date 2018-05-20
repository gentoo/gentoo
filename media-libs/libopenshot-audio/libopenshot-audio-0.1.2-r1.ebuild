# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Audio library used by OpenShot"
HOMEPAGE="https://www.openshot.org/ https://launchpad.net/libopenshot"
SRC_URI="https://github.com/OpenShot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
"
DEPEND="${RDEPEND}"

src_prepare() {
	# fix under-linking
	# https://github.com/OpenShot/libopenshot-audio/issues/3
	sed -i 's/^\(target_link_libraries(.*\))$/\1 dl pthread)/' \
		src/CMakeLists.txt || die
	cmake-utils_src_prepare
}
