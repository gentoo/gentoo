# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson xdg

DESCRIPTION="Modernized DOSBox soft-fork"
HOMEPAGE="https://dosbox-staging.github.io/"
SRC_URI="https://github.com/dosbox-staging/dosbox-staging/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa debug dynrec +fluidsynth mt-32 network opengl"

RDEPEND="alsa? ( media-libs/alsa-lib )
	debug? ( sys-libs/ncurses:0= )
	fluidsynth? (
		media-sound/fluid-soundfont
		media-sound/fluidsynth
	)
	network? ( media-libs/sdl2-net )
	opengl? ( virtual/opengl )
	media-libs/libpng:0=
	media-libs/libsdl2[joystick,opengl?,video,X]
	media-libs/opusfile
	sys-libs/zlib
	!games-emulation/dosbox"
DEPEND="${RDEPEND}"
BDEPEND=""

DOCS=( AUTHORS README THANKS )

src_prepare() {
	default

	# We do not have default.sf2, use actual name from fluid-soundfont
	sed -e "s/default.sf2/FluidR3_GM.sf2/" \
		-i src/midi/midi_fluidsynth.cpp || die

	# Disable license and docs install (handled by ebuild)
	sed -e "/licenses_dir\|doc_dir/d" -i meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use alsa use_alsa)
		$(meson_use debug)
		-Ddynamic_core=$(usex dynrec dynrec dyn-x86)
		$(meson_use fluidsynth use_fluidsynth)
		$(meson_use mt-32 use_mt32emu)
		$(meson_use network use_sdl2_net)
		$(meson_use opengl use_opengl)
	)
	meson_src_configure
}
