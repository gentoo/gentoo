# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop flag-o-matic xdg

DESCRIPTION="Modernized DOSBox soft-fork"
HOMEPAGE="https://dosbox-staging.github.io/"
SRC_URI="https://github.com/dosbox-staging/dosbox-staging/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa debug dynrec +fluidsynth network opengl opus"

RDEPEND="alsa? ( media-libs/alsa-lib )
	debug? ( sys-libs/ncurses:0= )
	fluidsynth? (
		media-sound/fluid-soundfont
		media-sound/fluidsynth
	)
	network? ( media-libs/sdl2-net )
	opengl? ( virtual/opengl )
	opus? ( media-libs/opusfile )
	media-libs/libpng:0=
	media-libs/libsdl2[joystick,opengl?,video,X]
	sys-libs/zlib
	!games-emulation/dosbox"
DEPEND="${RDEPEND}"
BDEPEND=""

src_prepare() {
	default

	# We do not have default.sf2, use actual name from fluid-soundfont
	sed -e "s/default.sf2/FluidR3_GM.sf2/" \
		-i src/midi/midi_fluidsynth.cpp || die

	eautoreconf
}

src_configure() {
	use debug || append-cppflags -DNDEBUG
	econf \
		$(use_enable alsa alsa-midi) \
		$(use_enable debug) \
		$(use_enable !dynrec dynamic-x86) \
		$(use_enable dynrec) \
		$(use_enable fluidsynth) \
		$(use_enable network) \
		$(use_enable opengl) \
		$(use_enable opus opus-cdda)
}

src_install() {
	default
	doicon -s scalable contrib/icons/${PN}.svg
	domenu contrib/linux/dosbox-staging.desktop
}
