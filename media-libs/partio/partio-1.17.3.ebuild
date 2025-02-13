# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake python-single-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wdas/partio.git"
else
	SRC_URI="https://github.com/wdas/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
fi

DESCRIPTION="Library for particle IO and manipulation"
HOMEPAGE="https://partio.us/"

LICENSE="BSD"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/freeglut
	media-libs/glu
	sys-libs/zlib
	virtual/opengl
"

DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
	)
"

BDEPEND="
	dev-lang/swig
	doc? (
		app-text/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"

src_configure() {
	local mycmakeargs=(
		"$(cmake_use_find_package doc Doxygen)"

		-DPARTIO_GTEST_ENABLED="$(usex test)" # "Enable GTest for tests"
		-DPARTIO_ORIGIN_RPATH="no" # "Enable ORIGIN rpath in the installed libraries"

		-DPARTIO_USE_GLVND="yes" # "Use GLVND for OpenGL"
		-DPARTIO_BUILD_SHARED_LIBS="yes" # "Enabled shared libraries"

		-DWDAS_CXX_STANDARD=17
	)

	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# fail on import partjson, partio
		testpartjson
		testpartio
	)

	cmake_src_test
}
