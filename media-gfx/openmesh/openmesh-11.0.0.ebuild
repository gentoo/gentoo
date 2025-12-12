# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="OpenMesh"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Generic data structure to represent and manipulate polygonal meshes"
HOMEPAGE="https://www.graphics.rwth-aachen.de/software/openmesh/"
SRC_URI="https://www.graphics.rwth-aachen.de/media/openmesh_static/Releases/$(ver_cut 1-2)/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="doc gui test"
RESTRICT="!test? ( test )"

RDEPEND="
	gui? (
		dev-qt/qtbase:6[gui,opengl,widgets]
		media-libs/libglvnd
	)
"
DEPEND="${RDEPEND}"
# texlive-latexextra for xcolor.sty
# texlive-latexrecommended for newunicodechar.sty
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-latexrecommended
	)
	test? (
		dev-cpp/eigen
		dev-cpp/gtest
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-11.0.0-gtest_detection.patch
	"${FILESDIR}"/${PN}-11.0.0-pkgconfig_instdir.patch
	"${FILESDIR}"/${PN}-11.0.0-rm_static_libs.patch
	"${FILESDIR}"/${PN}-11.0.0-tests_conditionnal.patch
	"${FILESDIR}"/${PN}-11.0.0-unused_flags.patch
)

src_prepare() {
	if use doc; then
		doxygen -u Doc/doxy.config.in 2>/dev/null || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		# Enable tools by default
		-DBUILD_APPS=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=$(usex !gui)
		-DOPENMESH_BUILD_UNIT_TESTS=$(usex test)
		-DOPENMESH_DOCS=$(usex doc)
		-DQT_VERSION=6
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_build doc
		# remove doxygen working files
		find "${BUILD_DIR}"/Build/share/OpenMesh/Doc/html/ \( \
			-iname '*.map' -o \
			-iname '*.md5' -o \
			-iname '*.repository' \
			\) -delete || die
	fi
}

src_test() {
	cp "${BUILD_DIR}"/src/Unittests/CTestTestfile.cmake "${BUILD_DIR}"/CTestTestfile.cmake || die
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/Build/$(get_libdir)"
	# parallel tests cause failures to each other
	cmake_src_test -j1
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/Build/share/OpenMesh/Doc/html/. )

	cmake_src_install

	# we don't want to install the unittests binaries
	if use test; then
		rm "${ED}"/usr/bin/unittests{,_customvec,_doublevec} || die
	fi
}
