# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="C library for cross-platform real-time audio input and output"
HOMEPAGE="http://libsound.io/"
SRC_URI="https://github.com/andrewrk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="alsa coreaudio examples jack pulseaudio static-libs"

DEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

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
