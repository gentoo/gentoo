# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# note: py3.11 is known failing at runtime with this version
PYTHON_COMPAT=( python3_{8..10} )
inherit check-reqs cmake multiprocessing python-single-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freeorion/freeorion.git"
else
	FREEORION_BUILD_ID="2021-08-01.f663dad"
	SRC_URI="https://github.com/freeorion/freeorion/releases/download/v${PV}/FreeOrion_v${PV}_${FREEORION_BUILD_ID}_Source.tar.gz"
	S="${WORKDIR}/src-tarball"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Free turn-based space empire and galactic conquest game"
HOMEPAGE="https://www.freeorion.org/"

LICENSE="GPL-2+ CC-BY-SA-3.0 LGPL-2.1+"
SLOT="0"
IUSE="dedicated doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-libs/boost:=[${PYTHON_USEDEP},nls,python]')
	sys-libs/zlib:=
	!dedicated? (
		media-libs/freetype
		media-libs/glew:=
		media-libs/libglvnd[X]
		media-libs/libogg
		media-libs/libpng:=
		media-libs/libsdl2[opengl,video]
		media-libs/libvorbis
		media-libs/openal
	)"
RDEPEND="
	${DEPEND}
	!dedicated? (
		media-fonts/dejavu
		media-fonts/roboto
	)"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	test? (
		$(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)"

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
		-DBUILD_HEADLESS=$(usex dedicated)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(usev doc)
}

src_test() {
	# freeoriond randomly(?) segfaults on exit, cause unknown but
	# seems fixed by some refactoring in -9999 (excluding for now)
	cmake_src_test -E 'SmokeTest(Game|Hostless)'

	epytest -o cache_dir="${T}"/pytest_cache default/python/tests
}

src_install() {
	local DOCS=( ChangeLog.md README.md )
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doc/cpp-apidoc/html

	if use dedicated; then
		rm -r "${ED}"/usr/share/freeorion/default/data/fonts || die
	else
		local font
		for font in roboto/Roboto-{Bold,Regular}.ttf dejavu/DejaVuSans{-Bold,}.ttf; do
			dosym -r /usr/share/{fonts/${font%/*},${PN}/default/data/fonts}/${font##*/}
		done
		rm "${ED}"/usr/share/${PN}/default/data/fonts/LICENSE.{Roboto,DejaVu} || die
	fi
}
