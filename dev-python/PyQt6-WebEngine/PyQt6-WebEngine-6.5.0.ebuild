# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=sip
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 flag-o-matic multiprocessing pypi qmake-utils

QT_PV=$(ver_cut 1-2):6

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug quick +widgets"

# can use parts of the Qt private api and "sometimes" needs rebuilds wrt :=
RDEPEND="
	>=dev-python/PyQt6-${PV}[gui,ssl,${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}=
	>=dev-qt/qtwebengine-${QT_PV}[widgets]
	quick? ( dev-python/PyQt6[qml] )
	widgets? ( dev-python/PyQt6[network,printsupport,webchannel,widgets] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/PyQt-builder-1.15[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
"

src_prepare() {
	default

	# hack: qmake queries g++ or clang++ for info depending on which qtbase was
	# built with, but ignores CHOST failing with -native-symlinks (bug #726112)
	# and potentially using wrong information when cross-compiling
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
