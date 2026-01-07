# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="JKQtPlotter"
DESCRIPTION="Extensive Qt Plotter framework"
HOMEPAGE="https://jkriege2.github.io/JKQtPlotter/"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jkriege2/${MY_PN}.git"
else
	SRC_URI="https://github.com/jkriege2/JKQtPlotter/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV/_/-}"
fi

LICENSE="LGPL-2.1+"
SLOT="0/5"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets,xml]
	dev-qt/qtsvg:6
"
RDEPEND="
	${DEPEND}
	dev-texlive/texlive-fontsextra
"
BDEPEND="
	doc? (
		app-text/doxygen
		dev-texlive/texlive-latex
		media-gfx/graphviz[cairo]
	)
"

PATCHES=(
	# bug #966047, https://github.com/jkriege2/JKQtPlotter/pull/156.patch
	"${FILESDIR}"/${PN}-5.0.0_beta1-qt6.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DJKQtPlotter_BUILD_DECORATE_LIBNAMES_WITH_BUILDTYPE=OFF
		-DJKQtPlotter_BUILD_EXAMPLES=OFF
		-DJKQtPlotter_BUILD_INCLUDE_FIRAMATH_FONTS=OFF # texlive-fontsextra
		-DJKQtPlotter_BUILD_INCLUDE_XITS_FONTS=OFF # texlive-fontsextra
		-DJKQtPlotter_BUILD_LIB_JKQTFASTPLOTTER=OFF # deprecated
		-DJKQtPlotter_BUILD_LIB_JKQTPLOTTER=ON
		-DJKQtPlotter_BUILD_TESTS=$(usex test)
		-DJKQtPlotter_BUILD_TOOLS=ON
		-DJKQtPlotter_BUILD_WITH_PRECOMPILED_HEADERS=OFF
		-DJKQtPlotter_ENABLED_CXX20=ON
		-DJKQtPlotter_HAS_NO_PRINTER_SUPPORT=OFF
		-DQT_VERSION_MAJOR=6
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_test() {
	if use x86; then
		local CMAKE_SKIP_TESTS+=(
			#JKQTPStringToolsTest.test_jkqtp_floattounitstr
			JKQTPStringTools_test
		)
	fi

	local -x QT_QPA_PLATFORM=offscreen
	LD_LIBRARY_PATH="${BUILD_DIR}/output" cmake_src_test
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )

	cmake_src_install

	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die

	# don't install test binaries
	if use test; then
		rm "${ED}"/usr/bin/*{benchmark,test}* || die
	fi
}
