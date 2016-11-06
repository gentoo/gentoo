# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

MY_PN="Shapely"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Geometric objects, predicates, and operations"
HOMEPAGE=" https://github.com/Toblerity/Shapely"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=sci-libs/geos-3.3
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# fix install path for Cython definition file
	sed -i \
		-e "s|\(data_files.*\)'shapely'|\1'share/shapely'|" \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}/lib" || die
	cp -r "${S}/tests" . || die
	py.test tests || die
}
