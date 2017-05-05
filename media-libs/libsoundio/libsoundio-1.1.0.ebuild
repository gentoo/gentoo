# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="C library for cross-platform real-time audio input and output"
HOMEPAGE="http://libsound.io/"
SRC_URI="http://libsound.io/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="alsa coreaudio examples jack pulseaudio static-libs"

# Build fails with <=media-sound/jack2-1.9.10
# See https://github.com/andrewrk/libsoundio/issues/7
# Only jack1 is supported for the time being
DEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	jack? ( >=media-sound/jack-audio-connection-kit-0.125.0[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}_missing_include.patch" )

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_COREAUDIO=$(usex coreaudio)
		-DENABLE_JACK=$(usex jack)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_WASAPI=no
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_EXAMPLE_PROGRAMS=$(multilib_native_usex examples)
		-DBUILD_TESTS=no
	)
	cmake-utils_src_configure
}
