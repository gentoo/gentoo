# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson xdg

DESCRIPTION="Modernized DOSBox soft-fork"
HOMEPAGE="https://dosbox-staging.github.io/"
SRC_URI="https://github.com/dosbox-staging/dosbox-staging/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug dynrec +fluidsynth mt-32 network opengl slirp test"

RESTRICT="!test? ( test )"

RDEPEND="debug? ( sys-libs/ncurses:0= )
	fluidsynth? (
		media-sound/fluid-soundfont
		media-sound/fluidsynth
	)
	mt-32? ( media-libs/munt-mt32emu )
	network? ( media-libs/sdl2-net )
	opengl? ( virtual/opengl )
	slirp? ( net-libs/libslirp )
	media-libs/alsa-lib
	media-libs/iir1
	media-libs/libpng:0=
	media-libs/libsdl2[alsa,joystick,opengl?,sound,video,X]
	media-libs/opusfile
	media-libs/speexdsp
	virtual/zlib:=
	sys-libs/zlib-ng:=
	!games-emulation/dosbox"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"

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
	# alsa is needed already by libsdl2[alsa,sound]
	# xinput2 comes with libsdl2[X]
	local emesonargs=(
		-Duse_alsa=true
		-Duse_xinput2=true
		-Duse_zlib_ng=native
		$(meson_use debug)
		-Ddynamic_core=$(usex dynrec dynrec dyn-x86)
		$(meson_use fluidsynth use_fluidsynth)
		$(meson_use mt-32 use_mt32emu)
		$(meson_use network use_sdl2_net)
		$(meson_use opengl use_opengl)
		$(meson_use slirp use_slirp)
		$(meson_feature test unit_tests)
	)
	meson_src_configure
}
