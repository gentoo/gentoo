# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{6..8} )
CMAKE_IN_SOURCE_BUILD=1

inherit cmake python-r1 virtualx

MY_P=pyside-setup-opensource-src-${PV}

DESCRIPTION="PySide development tools (lupdate, rcc, uic)"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"

# Though "LICENSE-uic" suggests the "pyside2uic" directory to be dual-licensed
# under the BSD 3-clause and GPL v2 licenses, this appears to be an oversight;
# all files in this (and every) directory are licensed only under the GPL v2.
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test tools"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Note that:
# * "pyside2uic" imports the "PySide2.QtGui" and "PySide2.QtWidgets" C
#   extensions and hence requires "widgets", which includes "gui" as well.
# * "dev-qt/qtchooser" installs binaries conflicting with the "tools" USE flag.
COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-python/pyside2-${PV}[widgets,${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	tools? ( !dev-qt/qtchooser )
"
DEPEND="${COMMON_DEPEND}
	test? ( virtual/pkgconfig )
"

S=${WORKDIR}/${MY_P}/sources/${PN}
DOCS=( README.md )

src_prepare() {
	cmake_src_prepare

	python_copy_sources

	pyside-tools_prepare() {
		pushd "${BUILD_DIR}" >/dev/null || die

		if python_is_python3; then
			# Remove Python 2-specific paths.
			rm -rf pyside2uic/port_v2 || die

			# Generate proper Python 3 test interfaces with the "-py3" option.
			sed -i -e \
				's~${PYSIDERCC_EXECUTABLE}~"${PYSIDERCC_EXECUTABLE} -py3"~' \
				tests/rcc/CMakeLists.txt || die
		else
			# Remove Python 3-specific paths.
			rm -rf pyside2uic/port_v3 || die
		fi

		# Force testing against the current Python version.
		sed -i -e "/pkg-config/ s:shiboken2:&-${EPYTHON}:" \
			tests/rcc/run_test.sh || die

		popd >/dev/null || die
	}

	python_foreach_impl pyside-tools_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
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

src_test() {
	# tests work only if tools USE flag enabled
	if [ use tools ]; then
		pyside-tools_test() {
			local -x PYTHONDONTWRITEBYTECODE
			CMAKE_USE_DIR="${BUILD_DIR}" virtx cmake_src_test
		}

		python_foreach_impl pyside-tools_test
	fi
}

src_install() {
	pyside-tools_install() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake_src_install
	}

	python_foreach_impl pyside-tools_install

	use tools || rm "${ED}"/usr/bin/{rcc,uic,designer} || die

	# Remove the broken "pyside_tool.py" script. By inspection, this script
	# reduces to a noop. Moreover, this script raises the following exception:
	#     FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin/../pyside_tool.py': '/usr/bin/../pyside_tool.py'
	rm "${ED}"/usr/bin/pyside_tool.py
}
