# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=sip
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 flag-o-matic multiprocessing pypi qmake-utils

QT_PV=$(ver_cut 1-2):6

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="debug quick +widgets"

RDEPEND="
	>=dev-python/pyqt6-${QT_PV%:*}[gui,ssl,webchannel,${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}[gui,widgets?]
	>=dev-qt/qtwebengine-${QT_PV}[widgets]
	quick? (
		dev-python/pyqt6[qml]
		>=dev-qt/qtwebengine-${QT_PV}[qml]
	)
	widgets? ( dev-python/pyqt6[network,printsupport,widgets] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/pyqt-builder-1.19[${PYTHON_USEDEP}]
	>=dev-python/sip-6.13.1[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
"

src_prepare() {
	default

	# hack: PyQt-builder runs qmake without our arguments and calls g++
	# or clang++ depending on what qtbase was built with, not used for
	# building but fails with -native-symlinks
	mkdir "${T}"/cxx || die
	local cxx
	! cxx=$(type -P "${CHOST}"-g++) || ln -s -- "${cxx}" "${T}"/cxx/g++ || die
	! cxx=$(type -P "${CHOST}"-clang++) || ln -s -- "${cxx}" "${T}"/cxx/clang++ || die
	PATH=${T}/cxx:${PATH}
}

python_configure_all() {
	append-cxxflags -std=c++17 # for old gcc / clang that use <17 (bug #892331)
	append-cxxflags ${CPPFLAGS} # respect CPPFLAGS notably for DISTUTILS_EXT=1

	DISTUTILS_ARGS=(
		--jobs="$(makeopts_jobs)"
		--qmake="$(qt6_get_bindir)"/qmake
		--qmake-setting="$(qt6_get_qmake_args)"
		--verbose

		--enable=QtWebEngineCore
		$(usex quick --{enable,disable}=QtWebEngineQuick)
		$(usex widgets --{enable,disable}=QtWebEngineWidgets)

		$(usev debug '--debug --qml-debug --tracing')
	)
}
