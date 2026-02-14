# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit check-reqs cmake flag-o-matic multiprocessing python-single-r1 xdg

DESCRIPTION="Free turn-based space empire and galactic conquest game"
HOMEPAGE="https://www.freeorion.org/"
SRC_URI="https://github.com/freeorion/freeorion/releases/download/v${PV}/FreeOrion-v${PV}_Source.tar.gz"
S=${WORKDIR}/FreeOrion-v${PV}--source

LICENSE="GPL-2+ CC-BY-SA-3.0 LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+client doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-libs/boost:=[${PYTHON_USEDEP},nls,python,zlib]')
	client? (
		media-libs/freetype
		media-libs/glew:0=
		media-libs/libglvnd
		media-libs/libpng:=
		media-libs/libsdl2[opengl,video]
		media-libs/libvorbis
		media-libs/openal
	)
"
RDEPEND="
	${DEPEND}
	client? (
		media-fonts/dejavu
		media-fonts/roboto
	)
"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	test? ( $(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]') )
"

PATCHES=(
	"${FILESDIR}"/${P}-config.h-path.patch
	"${FILESDIR}"/${P}-boost-1.89.patch # bug #969243, in 0.5.1.2
)

freeorion_check-reqs() {
	# cc1plus processes may suddenly use ~1.5GB all at once early on (2+GB
	# if debug symbols) then far less for the rest, check minimal jobs*1.5
	local CHECKREQS_MEMORY=$(($(makeopts_jobs)*1500))M
	check-reqs_${EBUILD_PHASE_FUNC}
}

pkg_pretend() {
	freeorion_check-reqs
}

pkg_setup() {
	freeorion_check-reqs
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -i 's/-O3//' CMakeLists.txt || die

	cmake_comment_add_subdirectory check #904124
}

src_configure() {
	filter-lto # -Werror=odr issues

	local mycmakeargs=(
		-DCCACHE_PROGRAM=no
		-DBUILD_CLIENT_GG=$(usex client)
		-DBUILD_CLIENT_GODOT=no # TODO?
		-DBUILD_TESTING=$(usex test)

		# temporary for doc/CMakeLists.txt which is using the old variable
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(usev doc)
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# needs looking into but failure does not seem(?) to affect runtime,
		# try to remove on bump
		TestChecksum
	)

	cmake_src_test -j1 # avoid running 2 conflicting servers

	local EPYTEST_DESELECT=(
		# broken with >=3.11 but is not known to cause issues, skip for now
		tests/AI/save_game_codec/test_savegame_manager.py::test_setstate_call
	)

	epytest -o cache_dir="${T}"/pytest_cache default/python/tests
}

src_install() {
	local DOCS=( ChangeLog.md README.md )
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doc/cpp-apidoc/html

	if use client; then
		local font
		for font in roboto/Roboto-{Bold,Regular}.ttf dejavu/DejaVuSans{-Bold,}.ttf; do
			dosym -r /usr/share/{fonts/${font%/*},${PN}/default/data/fonts}/${font##*/}
		done
		rm -- "${ED}"/usr/share/${PN}/default/data/fonts/LICENSE.{Roboto,DejaVu} || die
	else
		rm -r -- "${ED}"/usr/share/freeorion/default/data/fonts || die
	fi
}
