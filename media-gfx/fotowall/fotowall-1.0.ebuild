# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Qt5 tool for creating wallpapers"
HOMEPAGE="https://www.enricoros.com/opensource/fotowall/"
SRC_URI="https://github.com/enricoros/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="opengl webcam"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	opengl? ( dev-qt/qtopengl:5 )
"
DEPEND="${RDEPEND}
	webcam? ( media-libs/libv4l )
"

PATCHES=(
	"${FILESDIR}/${P}-qt-5.11.patch"
	"${FILESDIR}/${P}-qt-5.15.patch"
)

src_prepare() {
	default

	sed -i -e "s|linux/videodev.h|libv4l1-videodev.h|" \
		3rdparty/videocapture/VideoDevice.h || die

	if ! use opengl; then
		sed -i "/QT += opengl/d" ${PN}.pro || die
	fi
}

src_configure() {
	if ! use webcam; then
		eqmake5 ${PN}.pro "CONFIG+=no-webcam"
	else
		eqmake5
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.markdown
}
