# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=sip
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 flag-o-matic multiprocessing pypi qmake-utils

QT_PV="$(ver_cut 1-2):6"

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/"
SRC_URI="$(pypi_sdist_url --no-normalize ${PN/-/_})"
S="${WORKDIR}/${P/-/_}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug quick +widgets"

RDEPEND="
	>=dev-python/PyQt6-${PV}[gui,ssl,${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
	>=dev-qt/qtwebengine-${QT_PV}[widgets]
	quick? ( dev-python/PyQt6[qml] )
	widgets? ( dev-python/PyQt6[network,printsupport,webchannel,widgets] )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/PyQt-builder-1.11[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
	sys-devel/gcc"

src_prepare() {
	default

	# hack: qmake queries g++ directly for info (not building) and that doesn't
	# work with clang, this is to make it at least respect CHOST (bug #726112)
	mkdir "${T}"/cxx || die
	ln -s "$(type -P ${CHOST}-g++ || type -P g++ || die)" "${T}"/cxx/g++ || die
	PATH=${T}/cxx:${PATH}
}

src_configure() {
	append-cxxflags -std=c++17 # for old gcc / clang that use <17 (bug #892331)

	DISTUTILS_ARGS=(
		--jobs=$(makeopts_jobs)
		--qmake="$(type -P qmake6 || die)"
		--qmake-setting="$(qt5_get_qmake_args)"
		--verbose

		--enable=QtWebEngineCore
		$(usex quick --{enable,disable}=QtWebEngineQuick)
		$(usex widgets --{enable,disable}=QtWebEngineWidgets)

		$(usev debug '--debug --qml-debug --tracing')
	)
}
