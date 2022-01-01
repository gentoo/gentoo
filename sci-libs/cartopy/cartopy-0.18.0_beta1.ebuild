# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1 virtualx

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Python package for geospatial data processing and analysis"
HOMEPAGE="https://scitools.org.uk/cartopy"
SRC_URI="https://github.com/SciTools/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/pyshp[${PYTHON_USEDEP}]
	sci-libs/Shapely[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	sci-libs/gdal[python,${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	sci-libs/geos
	sci-libs/proj
"

distutils_enable_tests pytest

DEPEND+="test? (
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	# drop test file requiring network access, which got not covered by markers
	rm "${S}"/lib/cartopy/tests/mpl/test_crs.py || die
	# prepare matplotlib backend for test suite
	export MPLCONFIGDIR="${T}"
	echo "backend : Agg" > "${MPLCONFIGDIR}"/matplotlibrc || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}"
	# drop all tests needing network access
	virtx pytest -vv -m "not network and not natural_earth" || die "test failed"
}
