# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Library for asynchronous OpenGL recording with audio"
HOMEPAGE="https://github.com/Benau/libopenglrecorder"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openh264 sound vpx"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	media-libs/libjpeg-turbo[${MULTILIB_USEDEP}]
	openh264? ( media-libs/openh264[${MULTILIB_USEDEP}] )
	sound? (
		media-libs/libvorbis[${MULTILIB_USEDEP}]
		media-sound/pulseaudio[${MULTILIB_USEDEP}]
	)
	vpx? ( media-libs/libvpx:0=[${MULTILIB_USEDEP}] )"

RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md USAGE.md )

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_PULSE_WO_DL=ON
		-DSTATIC_RUNTIME_LIBS=OFF
		-DBUILD_WITH_H264=$(usex openh264)
		-DBUILD_RECORDER_WITH_SOUND=$(usex sound)
		-DBUILD_WITH_VPX=$(usex vpx)
	)
	cmake_src_configure
}
