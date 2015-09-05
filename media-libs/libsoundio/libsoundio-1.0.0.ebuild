# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib

DESCRIPTION="C99 library providing cross-platform audio input and output."
HOMEPAGE="http://libsound.io/"
SRC_URI="http://libsound.io/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="alsa coreaudio examples pulseaudio static-libs"

DEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

# All of these patches have been merged upstream (#8, #16, #20)
PATCHES=( "${FILESDIR}/${P}_clang.patch"
	"${FILESDIR}/${P}_static-libs.patch"
	"${FILESDIR}/${P}_examples_tests.patch" )

# ENABLE_JACK does not support the current version of jack1
# See https://github.com/andrewrk/libsoundio/issues/11
multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable alsa ALSA)
		$(cmake-utils_use_enable coreaudio COREAUDIO)
		-DENABLE_JACK=OFF
		$(cmake-utils_use_enable pulseaudio PULSEAUDIO)
		-DENABLE_WASAPI=OFF
		$(cmake-utils_use static-libs BUILD_STATIC_LIBS)
		-DBUILD_EXAMPLE_PROGRAMS=$(multilib_native_usex examples "ON" "OFF")
		-DBUILD_TESTS=OFF
	)
	cmake-utils_src_configure
}
