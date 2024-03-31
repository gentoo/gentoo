# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=sip
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 flag-o-matic multiprocessing pypi qmake-utils

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="
	https://www.riverbankcomputing.com/software/pyqtwebengine/
	https://pypi.org/project/PyQtWebEngine/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"
IUSE="debug"

DEPEND="
	>=dev-python/PyQt5-5.15.5[gui,network,printsupport,ssl,webchannel,widgets,${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtwebengine:5[widgets]
"
RDEPEND="
	${DEPEND}
	>=dev-python/PyQt5-sip-12.9:=[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/PyQt-builder-1.10[${PYTHON_USEDEP}]
	>=dev-python/sip-6.2[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
"

python_configure_all() {
	append-cxxflags ${CPPFLAGS} # respect CPPFLAGS notably for DISTUTILS_EXT=1

	DISTUTILS_ARGS=(
		--jobs="$(makeopts_jobs)"
		--qmake="$(qt5_get_bindir)"/qmake
		--qmake-setting="$(qt5_get_qmake_args)"
		--verbose
		$(usev debug '--debug --qml-debug --tracing')
	)
}
