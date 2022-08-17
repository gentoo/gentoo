# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

PYTHON_COMPAT=( python3_{8..11} )

inherit python-single-r1 cmake docs virtualx xdg

DESCRIPTION="Application for Scientific Data Analysis and Visualization"
HOMEPAGE="http://scidavis.sourceforge.net/ https://github.com/SciDAVis/scidavis/"
SRC_URI="https://github.com/SciDAVis/scidavis/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ ZLIB"
KEYWORDS="~amd64"
SLOT="0"

IUSE="doc origin python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# requires network
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	dev-cpp/muParser
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sci-libs/gsl:=
	sys-libs/zlib[minizip]
	x11-libs/qwt:5
	x11-libs/qwtplot3d
	origin? ( sci-libs/liborigin )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/PyQt5-5.15.6[${PYTHON_USEDEP}]
			dev-python/PyQt5-sip[${PYTHON_USEDEP}]
			>=dev-python/sip-6:5[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	test? (
		dev-libs/unittest++
		dev-cpp/gtest
	)
"

src_prepare() {
	cmake_src_prepare

	# Remove things which are packaged elsewhere
	rm -r 3rdparty/qwt5-qt5 3rdparty/qwtplot3d 3rdparty/liborigin || die

	# OF has been renamed in Gentoo https://bugs.gentoo.org/383179
	# Note this is *not* packaged in sys-libs/zlib[minizip] because
	# this file resides in the test directory in upstream zlib
	sed -i -r 's:\<(O[FN])\>:_Z_\1:g' 3rdparty/minigzip/minigzip.c || die
}

src_configure() {
	local mycmakeargs=(
		# Even if we disable muparser scripting, we still need MuParser.h
		# for Graph3D.cpp. So just enable it unconditionally. Bug 834074
		-DSCRIPTING_MUPARSER=ON
		-DORIGIN_IMPORT=$(usex origin)
		-DSCRIPTING_PYTHON=$(usex python)
		-DBUILD_TESTS=$(usex test)
	)

	if use python; then
		mycmakeargs+=(
			-DPYTHON_SCRIPTDIR="$(python_get_scriptdir)"
		)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	docs_compile
}

src_test() {
	virtx cmake_src_test
}
