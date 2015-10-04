# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib

DESCRIPTION="C99 library providing cross-platform audio input and output"
HOMEPAGE="http://libsound.io/"
SRC_URI="http://libsound.io/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="alsa coreaudio examples pulseaudio static-libs"

DEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

# ENABLE_JACK does not support the current version of jack1
# See https://github.com/andrewrk/libsoundio/issues/11
multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_COREAUDIO=$(usex coreaudio)
		-DENABLE_JACK=no
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_WASAPI=no
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_EXAMPLE_PROGRAMS=$(multilib_native_usex examples)
		-DBUILD_TESTS=no
	)
	cmake-utils_src_configure
}
