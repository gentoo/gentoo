# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake python-single-r1

MY_PN=${PN^}

DESCRIPTION="Imath basic math package"
HOMEPAGE="https://imath.readthedocs.io"
SRC_URI="https://github.com/AcademySoftwareFoundation/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="3/29"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc large-stack python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		$(python_gen_cond_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-press-theme[${PYTHON_USEDEP}]
		')
	)
	python? ( ${PYTHON_DEPS} )
"

DOCS=( CHANGES.md CONTRIBUTORS.md README.md SECURITY.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_WEBSITE=$(usex doc)
		-DIMATH_ENABLE_LARGE_STACK=$(usex large-stack)
		# the following options are at their default value
		-DIMATH_HALF_USE_LOOKUP_TABLE=ON
		-DIMATH_INSTALL_PKG_CONFIG=ON
		-DIMATH_USE_CLANG_TIDY=OFF
		-DIMATH_USE_DEFAULT_VISIBILITY=OFF
		-DIMATH_USE_NOEXCEPT=ON
	)
	if use python; then
		mycmakeargs+=(
			-DBoost_NO_BOOST_CMAKE=OFF
			-DPYTHON=ON
			-DPython3_EXECUTABLE="${PYTHON}"
			-DPython3_INCLUDE_DIR="$(python_get_includedir)"
			-DPython3_LIBRARY="$(python_get_library_path)"
		)
	fi

	cmake_src_configure
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}/website/sphinx/." )
	cmake_src_install
}
