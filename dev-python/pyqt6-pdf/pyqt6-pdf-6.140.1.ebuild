# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=sip
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 flag-o-matic multiprocessing pypi qmake-utils

DESCRIPTION="Python bindings for QtPdf"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtpdf/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="debug +widgets"

RDEPEND="
	>=dev-python/pyqt6-6.12.0[gui,widgets?,${PYTHON_USEDEP}]
	dev-qt/qtbase:6[gui,widgets?]
	>=dev-qt/qtwebengine-$(ver_cut 1-2):6[pdfium,widgets?]
	!dev-python/pyqt6[pdfium(-)]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/pyqt-builder-1.21[${PYTHON_USEDEP}]
	>=dev-python/sip-6.17[${PYTHON_USEDEP}]
	dev-qt/qtbase:6
"

src_prepare() {
	default

	# hack: PyQt-builder runs qmake without our arguments and calls g++
	# or clang++ depending on what qtbase was built with, not used for
	# building but fails with -native-symlinks
	# TODO: maybe qmake-utils.eclass should implement this itself
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
		--qmake="$(qt_get_broot_binary 6 qmake)"
		--qmake-setting="$(qt6_get_qmake_args)"
		--verbose

		--enable=QtPdf
		$(usex widgets --{enable,disable}=QtPdfWidgets)

		$(usev debug '--debug --qml-debug --tracing')
	)
}
