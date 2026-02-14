# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Accuracy-focused XAudio reimplementation for open platforms"
HOMEPAGE="https://fna-xna.github.io/"
SRC_URI="https://github.com/FNA-XNA/FAudio/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FAudio-${PV}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug dumpvoices sdl3 test"
RESTRICT="!test? ( test )"

RDEPEND="
	sdl3? ( media-libs/libsdl3[${MULTILIB_USEDEP}] )
	!sdl3? ( media-libs/libsdl2[${MULTILIB_USEDEP},sound] )
"
DEPEND="${RDEPEND}"

src_configure() {
	append-cppflags -D_DEFAULT_SOURCE # usleep() in tests
	use debug || append-cppflags -DFAUDIO_DISABLE_DEBUGCONFIGURATION

	local mycmakeargs=(
		-DBUILD_SDL3="$(usex sdl3)"
		-DBUILD_TESTS="$(usex test)"
		-DDUMP_VOICES="$(usex dumpvoices)"
	)

	cmake-multilib_src_configure
}

multilib_src_test() {
	einfo "Running faudio_tests, this may take some time without output..."
	SDL_AUDIODRIVER=dummy "${BUILD_DIR}"/faudio_tests || die
}
