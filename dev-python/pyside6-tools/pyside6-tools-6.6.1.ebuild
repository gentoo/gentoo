# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake python-r1

MY_PN="pyside-setup-everywhere-src"

DESCRIPTION="PySide development tools (pyside6-lupdate with support for Python)"
HOMEPAGE="https://wiki.qt.io/PySide6"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-${PV}-src/${MY_PN}-${PV}.tar.xz"
S="${WORKDIR}/${MY_PN}-${PV}/sources/pyside-tools"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	~dev-python/pyside6-${PV}[quick,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare

	python_copy_sources
}

src_configure() {
	pyside-tools_configure() {
		local mycmakeargs=(
			# If this is enabled cmake just makes copies of /lib64/qt6/bin/*
			-DNO_QT_TOOLS=yes
		)
		cmake_src_configure
	}

	python_foreach_impl pyside-tools_configure
}

src_compile() {
	pyside-tools_compile() {
		cmake_src_compile
	}

	python_foreach_impl pyside-tools_compile
}

src_install() {
	pyside-tools_install() {
		# This replicates the contents of the PySide6 pypi wheel
		DESTDIR="${BUILD_DIR}" cmake_build install
		cp __init__.py "${BUILD_DIR}/usr/bin" || die
		rm -r  "${BUILD_DIR}/usr/bin/qtpy2cpp_lib/tests" || die
		python_moduleinto PySide6/scripts
		python_domodule "${BUILD_DIR}/usr/bin/."
	}

	python_foreach_impl pyside-tools_install

	einstalldocs
}
