# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Accuracy-focused XAudio reimplementation for open platforms"
HOMEPAGE="https://fna-xna.github.io/"
SRC_URI="https://github.com/FNA-XNA/FAudio/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FAudio-${PV}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dumpvoices test"
RESTRICT="!test? ( test )"

RDEPEND="media-libs/libsdl2[sound]"
DEPEND="${RDEPEND}"

src_configure() {
	append-cppflags -D_DEFAULT_SOURCE # usleep() in tests
	use debug || append-cppflags -DFAUDIO_DISABLE_DEBUGCONFIGURATION

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DDUMP_VOICES=$(usex dumpvoices)
	)

	cmake_src_configure
}

src_test() {
	einfo "Running faudio_tests, this may take some time without output..."
	SDL_AUDIODRIVER=dummy "${BUILD_DIR}"/faudio_tests || die
}
