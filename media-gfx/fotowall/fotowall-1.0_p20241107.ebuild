# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="d31d3960b2a8a721e274300c1150de48ca219897"
inherit qmake-utils

DESCRIPTION="Qt tool for creating wallpapers"
HOMEPAGE="https://www.enricoros.com/opensource/fotowall/"
SRC_URI="https://github.com/enricoros/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz
	https://dev.gentoo.org/~asturm/distfiles/${P}-patchset.tar.xz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="webcam"

RDEPEND="
	dev-qt/qtbase:6[gui,network,opengl,widgets,xml]
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}
	webcam? ( media-libs/libv4l )
"

# Extracted Qt6-only changes (and ported to qmake) from:
# https://github.com/fotowall/fotowall/pull/43
PATCHES=( "${WORKDIR}"/${P}-patchset )

src_prepare() {
	default

	sed -i -e "s|linux/videodev.h|libv4l1-videodev.h|" \
		3rdparty/videocapture/VideoDevice.h || die
}

src_configure() {
	if ! use webcam; then
		eqmake6 ${PN}.pro "CONFIG+=no-webcam"
	else
		eqmake6
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md
}
