# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Sphinx doc building is not compatible with in-tree version of sphinx-bibtex:
# Extension error: You must configure the bibtex_bibfiles setting
#
# PYTHON_COMPAT=( python3_{8..10} )
# DOCS_BUILDER="sphinx"
# DOCS_DEPEND="
# 	dev-python/sphinxcontrib-bibtex
# 	dev-python/sphinx-rtd-theme
# "

inherit cmake xdg # python-any-r1 docs

DESCRIPTION="General purpose computer algebra system"
HOMEPAGE="https://www.yacas.org/"
SRC_URI="https://github.com/grzegorzmazur/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 gui? ( MIT Apache-2.0 OFL-1.1 )"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="gui +jupyter static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	gui? (
		dev-libs/mathjax
		dev-qt/qtcore:5[icu]
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtwidgets:5
	)
	jupyter? (
		dev-libs/boost:=
		dev-libs/jsoncpp:=
		dev-libs/openssl:0=
		dev-python/jupyter
		net-libs/zeromq
		>=net-libs/zmqpp-4.1.2
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	# respect DESTDIR. avoid sandbox violation
	sed -i -e 's/${CMAKE_INSTALL_PREFIX}/\\$ENV{DESTDIR}\/${CMAKE_INSTALL_PREFIX}/g' \
		cyacas/yacas-gui/resources/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# TODO: Unbundle CodeMirror
	local mycmakeargs=(
		-DENABLE_CYACAS_BENCHMARKS=OFF
		-DENABLE_DOCS=OFF
		# -DENABLE_DOCS=$(usex doc)
		-DENABLE_JYACAS=OFF # requires manual install
		-DENABLE_CYACAS_GUI=$(usex gui)
		# use system version of mathjax instead
		-DENABLE_CYACAS_GUI_PRIVATE_MATHJAX=OFF
		-DMATHJAX_PATH="${EPREFIX}/usr/share/mathjax/MathJax.js"
		-DENABLE_CYACAS_KERNEL=$(usex jupyter)
		-DENABLE_CYACAS_UNIT_TESTS=$(usex test)
	)
	cmake_src_configure
}
