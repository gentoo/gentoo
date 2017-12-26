# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A library allowing optional async readback OpenGL frame buffer with optional audio recording"
HOMEPAGE="https://github.com/Benau/libopenglrecorder"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vpx openh264 -pulseaudio"

DEPEND="media-libs/libjpeg-turbo vpx? ( media-libs/libvpx ) openh264? ( media-libs/openh264 ) pulseaudio? ( media-sound/pulseaudio )"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
			-DBUILD_SHARED_LIBS=ON
			-DBUILD_WITH_VPX=$(usex vpx)
			-DBUILD_WITH_H264=$(usex openh264)
			-DBUILD_RECORDER_WITH_SOUND=$(usex pulseaudio)
			-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
			-DCMAKE_BUILD_TYPE=Release
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
