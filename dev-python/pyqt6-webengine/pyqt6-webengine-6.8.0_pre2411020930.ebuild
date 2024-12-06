# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=sip
PYPI_NO_NORMALIZE=1
# actually, it's PyQt6-WebEngine but upstream uses incorrect sdist name
PYPI_PN=PyQt6_WebEngine
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 flag-o-matic multiprocessing qmake-utils # pypi

QT_PV=$(ver_cut 1-2):6

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/"

# TODO: drop this and uncomment 'pypi' on a proper bump
MY_P=${PYPI_PN}-$(ver_cut 1-3).dev$(ver_cut 5)
SRC_URI="https://www.riverbankcomputing.com/pypi/packages/PyQt6-WebEngine/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="debug quick +widgets"

RDEPEND="
	>=dev-python/pyqt6-${QT_PV%:*}[gui,ssl,${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}[gui,widgets?]
	>=dev-qt/qtwebengine-${QT_PV}[widgets]
	quick? (
		dev-python/pyqt6[qml]
		>=dev-qt/qtwebengine-${QT_PV}[qml]
	)
	widgets? ( dev-python/pyqt6[network,printsupport,webchannel,widgets] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/pyqt-builder-1.17[${PYTHON_USEDEP}]
	>=dev-python/sip-6.9[${PYTHON_USEDEP}]
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
