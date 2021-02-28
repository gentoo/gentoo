# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{7..8} )
CMAKE_IN_SOURCE_BUILD=1

inherit cmake python-r1

MY_P=pyside-setup-opensource-src-${PV}

DESCRIPTION="PySide development tools (pyside2-lupdate with support for Python)"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="${PYTHON_DEPS}
	>=dev-python/pyside2-${PV}[${PYTHON_USEDEP}]
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

S=${WORKDIR}/${MY_P}/sources/${PN}
DOCS=( README.md )

# the tools conflict with tools from QT
PATCHES=(
	"${FILESDIR}/${P}-dont-install-tools.patch"
)

src_prepare() {
	cmake_src_prepare

	python_copy_sources
}

src_configure() {
	# The tests are only related to the tools that we don't install
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
	)

	pyside-tools_configure() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		)
		CMAKE_USE_DIR="${BUILD_DIR}" cmake_src_configure
	}

	python_foreach_impl pyside-tools_configure
}

src_compile() {
	pyside-tools_compile() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake_src_compile
	}

	python_foreach_impl pyside-tools_compile
}

src_install() {
	pyside-tools_install() {
		python_doexe "${BUILD_DIR}/pylupdate/pyside2-lupdate"
	}

	python_foreach_impl pyside-tools_install

	doman pylupdate/pyside2-lupdate.1
	einstalldocs
}
