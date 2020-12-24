# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit cmake python-single-r1 fortran-2

DESCRIPTION="compressed numerical arrays with high-speed random access"
HOMEPAGE="https://computing.llnl.gov/projects/zfp"
SRC_URI="https://github.com/LLNL/zfp/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples python openmp test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

DEPEND="
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	fortran-2_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CFP=ON
		-DBUILD_ZFORP=ON
		-DBUILD_UTILITIES=ON
		-DBUILD_ZFPY=$(usex python)
		-DZFP_WITH_OPENMP=$(usex openmp)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
