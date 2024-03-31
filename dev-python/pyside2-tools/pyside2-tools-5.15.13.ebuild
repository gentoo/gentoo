# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{10..11} )

LLVM_COMPAT=( 15 )

inherit cmake llvm-r1 python-r1

MY_P=pyside-setup-opensource-src-${PV}

DESCRIPTION="PySide development tools (pyside2-lupdate with support for Python)"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}/sources/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	~dev-python/shiboken2-${PV}[${PYTHON_USEDEP},${LLVM_USEDEP}]
	~dev-python/pyside2-${PV}[${PYTHON_USEDEP},${LLVM_USEDEP}]
"
DEPEND="${RDEPEND}
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/llvm:${LLVM_SLOT}
	')
"

# the tools conflict with tools from QT
PATCHES=(
	"${FILESDIR}/${PN}-5.15.11-no-copy-uic.patch"
)

src_prepare() {
	cmake_src_prepare

	python_copy_sources
}

src_configure() {
	pyside-tools_configure() {
		local mycmakeargs=(
			-DBUILD_TESTS=OFF
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
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
		dobin "${BUILD_DIR}/usr/bin/pyside2-lupdate"
		python_moduleinto PySide2/scripts
		python_domodule "${BUILD_DIR}/usr/bin/pyside_tool.py"
	}

	python_foreach_impl pyside-tools_install

	einstalldocs
}
