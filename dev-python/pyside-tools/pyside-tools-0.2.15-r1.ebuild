# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_IN_SOURCE_BUILD="1"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
VIRTUALX_COMMAND="cmake-utils_src_test"

inherit eutils cmake-utils python-r1 vcs-snapshot virtualx

DESCRIPTION="PySide development tools (lupdate, rcc, uic)"
HOMEPAGE="http://qt-project.org/wiki/PySide"
SRC_URI="https://github.com/PySide/Tools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-python/pyside-1.2.0[X,${PYTHON_USEDEP}]
	>=dev-python/shiboken-1.2.0[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-4.7.0:4
	>=dev-qt/qtgui-4.7.0:4
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	test? ( virtual/pkgconfig )"

src_prepare() {
	epatch "${FILESDIR}"/0.2.13-fix-pysideuic-test-and-install.patch

	python_copy_sources

	preparation() {
		pushd "${BUILD_DIR}" >/dev/null || die
		if python_is_python3; then
			rm -fr pysideuic/port_v2
		else
			rm -fr pysideuic/port_v3
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
			$(cmake-utils_use_build test TESTS)
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
		CMAKE_USE_DIR="${BUILD_DIR}" virtualmake
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake-utils_src_install DESTDIR="${D}"
	}
	python_foreach_impl installation

	dodoc AUTHORS
}
