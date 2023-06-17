# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Library for asynchronous OpenGL recording with audio"
HOMEPAGE="https://github.com/Benau/libopenglrecorder"
SRC_URI="https://github.com/Benau/libopenglrecorder/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="openh264 sound vpx"

DEPEND="
	media-libs/libjpeg-turbo[${MULTILIB_USEDEP}]
	openh264? ( media-libs/openh264[${MULTILIB_USEDEP}] )
	sound? (
		media-libs/libpulse[${MULTILIB_USEDEP}]
		media-libs/libvorbis[${MULTILIB_USEDEP}]
	)
	vpx? ( media-libs/libvpx:0=[${MULTILIB_USEDEP}] )"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

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
