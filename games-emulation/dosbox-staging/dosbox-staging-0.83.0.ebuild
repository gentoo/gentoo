# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

# Nuked SC-55 CLAP audio plugin
SC55PV=0.11.0
SC55_S="${WORKDIR}/Nuked-SC55-CLAP-${SC55PV}"
SC55_BUILD_DIR="${SC55_S}_build"

DESCRIPTION="Modernized DOSBox soft-fork"
HOMEPAGE="https://dosbox-staging.github.io/"
SRC_URI="https://github.com/dosbox-staging/dosbox-staging/archive/v${PV}.tar.gz -> ${P}.tar.gz
	sc55? (
		https://github.com/johnnovak/Nuked-SC55-CLAP/archive/refs/tags/v${SC55PV}.tar.gz
			-> Nuked-SC55-CLAP-${SC55PV}.tar.gz
	)"

LICENSE="GPL-2+ sc55? ( XMAME )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug dynrec mt-32 opengl +sc55 slirp test"

RESTRICT="!test? ( test )"

RDEPEND="debug? ( sys-libs/ncurses:0= )
	mt-32? ( media-libs/munt-mt32emu )
	opengl? ( virtual/opengl )
	slirp? ( net-libs/libslirp )
	dev-cpp/asio
	media-libs/alsa-lib
	media-libs/iir1
	media-libs/libpng:0=
	media-libs/libsdl2[alsa,joystick,opengl?,sound,video,X]
	media-libs/opusfile
	media-libs/speexdsp
	media-sound/fluid-soundfont
	media-sound/fluidsynth
	virtual/zlib:=
	sys-libs/zlib-ng:=
	!games-emulation/dosbox"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-cpp/gtest )
	sc55? ( virtual/pkgconfig )"

DOCS=( README.md docs/AUTHORS )

src_prepare() {
	cmake_src_prepare

	# We do not have default.sf2, use actual name from fluid-soundfont
	sed -e "s/default.sf2/FluidR3_GM.sf2/" \
		-i src/midi/fluidsynth.cpp || die

	# Disable license install
	# Fix install path
	sed -e '/install(.*license/I,/)/d' \
		-e 's#${RESOURCE_COPY_PATH}#\0/#' \
		-i cmake/add_install_rules.cmake || die

	use sc55 && CMAKE_USE_DIR="${SC55_S}" BUILD_DIR="${SC55_BUILD_DIR}" cmake_prepare
}

src_configure() {
	if use sc55; then
		CMAKE_USE_DIR="${SC55_S}" BUILD_DIR="${SC55_BUILD_DIR}" cmake_src_configure
	fi

	# alsa is needed already by libsdl2[alsa,sound]
	# xinput2 comes with libsdl2[X]
	local mycmakeargs=(
		-DUSE_SYSTEM_LIBS=ON
		-DOPT_XINPUT=ON
		-DOPT_DEBUGGER=$(usex debug)
		-DOPT_FORCE_DYNREC=$(usex dynrec)
		-DOPT_MT32EMU=$(usex mt-32)
		-DOPT_OPENGL=$(usex opengl)
		-DOPT_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	use sc55 && CMAKE_USE_DIR="${SC55_S}" BUILD_DIR="${SC55_BUILD_DIR}" cmake_src_compile
	cmake_src_compile
}

src_install() {
	if use sc55; then
		insinto /usr/share/dosbox-staging/plugins
		doins "${SC55_BUILD_DIR}/Nuked-SC55.clap"
	fi
	cmake_src_install
}
