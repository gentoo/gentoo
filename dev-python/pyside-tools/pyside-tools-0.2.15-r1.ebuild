# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD="1"
CMAKE_MAKEFILE_GENERATOR="emake" # bug 558248

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit cmake-utils python-r1 vcs-snapshot virtualx

DESCRIPTION="PySide development tools (lupdate, rcc, uic)"
HOMEPAGE="http://wiki.qt.io/PySide"
SRC_URI="https://github.com/PySide/Tools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/pyside-1.2.0:${SLOT}[X,${PYTHON_USEDEP}]
	>=dev-python/shiboken-1.2.0:${SLOT}[${PYTHON_USEDEP}]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}
	test? ( virtual/pkgconfig )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/0.2.13-fix-pysideuic-test-and-install.patch
)

src_prepare() {
	cmake-utils_src_prepare

	python_copy_sources

	preparation() {
		pushd "${BUILD_DIR}" >/dev/null || die

		if python_is_python3; then
			rm -fr pysideuic/port_v2 || die

			# need to run with -py3 to generate proper python 3 interfaces
			sed -i -e 's:${PYSIDERCC_EXECUTABLE}:"${PYSIDERCC_EXECUTABLE} -py3":' \
				tests/rcc/CMakeLists.txt || die
		else
			rm -fr pysideuic/port_v3 || die
		fi

		sed -i -e "/pkg-config/ s:shiboken:&-${EPYTHON}:" \
			tests/rcc/run_test.sh || die

		popd >/dev/null || die
	}
	python_foreach_impl preparation
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DPYTHON_BASENAME="-${EPYTHON}"
			-DPYTHON_SUFFIX="-${EPYTHON}"
			-DBUILD_TESTS=$(usex test)
		)
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	compilation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_make
	}
	python_foreach_impl compilation
}

src_test() {
	testing() {
		CMAKE_USE_DIR="${BUILD_DIR}" virtx cmake-utils_src_test
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_install DESTDIR="${D}"
	}
	python_foreach_impl installation
}
