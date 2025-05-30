# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A set of C++ classes that provide a common API for realtime MIDI input/output"
HOMEPAGE="https://www.music.mcgill.ca/~gary/rtmidi"
SRC_URI="https://www.music.mcgill.ca/~gary/rtmidi/release/${P}.tar.gz"

LICENSE="RtMidi"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+alsa jack test"
RESTRICT="!test? ( test )"

DEPEND="
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DRTMIDI_API_ALSA=$(usex alsa)
		-DRTMIDI_API_JACK=$(usex jack)
		-DRTMIDI_BUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
