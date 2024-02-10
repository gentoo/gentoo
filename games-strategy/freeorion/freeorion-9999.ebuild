# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit check-reqs cmake multiprocessing python-single-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freeorion/freeorion.git"
else
	SRC_URI="https://github.com/freeorion/freeorion/releases/download/v${PV}/FreeOrion_v${PV}_Source.tar.gz"
	S="${WORKDIR}/src-tarball"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Free turn-based space empire and galactic conquest game"
HOMEPAGE="https://www.freeorion.org/"

LICENSE="GPL-2+ CC-BY-SA-3.0 LGPL-2.1+"
SLOT="0"
IUSE="+client doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-libs/boost:=[${PYTHON_USEDEP},nls,python]')
	sys-libs/zlib:=
	client? (
		media-libs/freetype
		media-libs/glew:=
		media-libs/libglvnd
		media-libs/libogg
		media-libs/libpng:=
		media-libs/libsdl2[opengl,video]
		media-libs/libvorbis
		media-libs/openal
	)"
RDEPEND="
	${DEPEND}
	client? (
		media-fonts/dejavu
		media-fonts/roboto
	)"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	test? (
		$(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)"

PATCHES=(
	"${FILESDIR}/freeorion-0.5-ccache.patch"
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
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT_GG=$(usex client)
		-DBUILD_CLIENT_GODOT=no # TODO, perhaps with system godot (experimental)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(usev doc)
}

src_test() {
	cmake_src_test -j1 # avoid running 2 conflicting servers

	local EPYTEST_DESELECT=(
		# broken with 3.11 but is not known to cause issues, just skip for now
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
		rm "${ED}"/usr/share/${PN}/default/data/fonts/LICENSE.{Roboto,DejaVu} || die
	else
		rm -r "${ED}"/usr/share/freeorion/default/data/fonts || die
	fi
}
