# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 multibuild multiprocessing virtualx

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Python package for geospatial data processing and analysis"
HOMEPAGE="https://scitools.org.uk/cartopy"
SRC_URI="https://github.com/SciTools/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sci-libs/gdal[python,${PYTHON_SINGLE_USEDEP}]
	sci-libs/geos
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
		dev-python/shapely[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/pillow[jpeg,${PYTHON_USEDEP}]
		dev-python/pyproj[${PYTHON_USEDEP}]
		sci-libs/pyshp[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools_scm[${PYTHON_USEDEP}]
		dev-python/cython[${PYTHON_USEDEP}]
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/filelock[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/flufl-lock[${PYTHON_USEDEP}]
			dev-python/pytest-mpl[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=( "${FILESDIR}"/${P}-fix-test.patch )

EPYTEST_IGNORE=(
	# Require network access, not covered by markers
	lib/cartopy/tests/mpl/test_crs.py
	lib/cartopy/tests/mpl/test_gridliner.py
)

distutils_enable_tests pytest

python_prepare_all() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

	# Prepare matplotlib backend for test suite
	export MPLCONFIGDIR="${T}"
	echo "backend : Agg" > "${MPLCONFIGDIR}"/matplotlibrc || die

	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}" || die

	# Drop all tests needing network access
	virtx epytest -n "$(makeopts_jobs)" -m "not network and not natural_earth" || die "test failed"
}
