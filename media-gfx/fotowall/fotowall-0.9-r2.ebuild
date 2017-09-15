# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Qt4 tool for creating wallpapers"
HOMEPAGE="https://www.enricoros.com/opensource/fotowall/"
SRC_URI="https://github.com/enricoros/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="opengl webcam"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	opengl? ( dev-qt/qtopengl:4 )
"
DEPEND="${RDEPEND}
	webcam? ( media-libs/libv4l )
"

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
		eqmake4 ${PN}.pro "CONFIG+=no-webcam"
	else
		eqmake4
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.markdown
}
