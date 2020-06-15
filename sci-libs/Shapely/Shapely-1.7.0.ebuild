# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

#MY_PN="Shapely"
#MY_P="${MY_PN}-${PV}"

DESCRIPTION="Geometric objects, predicates, and operations"
HOMEPAGE="https://pypi.org/project/Shapely/"
#SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
  dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/geos-3.3
"

BDEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
  dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

RESTRICT="!test? ( test )"

#S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# fix install path for Cython definition file
	sed -i -e "s|\(data_files.*\)'shapely'|\1'share/shapely'|" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}/lib" || die
	cp -r "${S}/tests" . || die
	py.test tests || die
}
