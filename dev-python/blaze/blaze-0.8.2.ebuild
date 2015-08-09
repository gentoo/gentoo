# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Next generation Python numpy"
HOMEPAGE="http://blaze.pydata.org/"
SRC_URI="https://github.com/ContinuumIO/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# Currently doc build fails, reason now, attempt to import mystery modules in datashape
# Leaving doc build content in case this is fixed
IUSE="examples test"

# pyspark appears an optional dep not in portage. pyskit appears to be dropped
# some packages including pyparsing appear required despite their absence from requirements.txt

RDEPEND="
	<dev-python/datashape-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/dynd-python-0.6.5[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/cytoolz[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.15.0[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/unicodecsv[${PYTHON_USEDEP}]
	>=dev-python/multipledispatch-0.4.7[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pytables-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pymongo-2.8[${PYTHON_USEDEP}]
	dev-python/xlrd[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/into[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numba[${PYTHON_USEDEP}]
	dev-python/bcolz[${PYTHON_USEDEP}]
	>=dev-python/odo-0.3.1[${PYTHON_USEDEP}]"
DEPEND="
	>=dev-python/cython-0.18[${PYTHON_USEDEP}]
	test? (  ${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}] )
	"
# It was found on testing that dev-python/chardet is required for tests
# despite not being inlcuded in requirements.txt
# The doc build now fails due to dep bokeh failing to emerge. Deleted.

python_test() {
	# https://github.com/ContinuumIO/blaze/issues/1117
	# skip test requiring a server daemon
	# Tally of known failure reduced to one under py2.7 (test_highly_nested_repr)
	# and 2 under py3. The failure of test_query_with_strings persists
	# under python3 and appears to be unaddressed upstream.
	# Changes in the suite in this version require PYTHONPATH set to ${S}
	# to avoid spurious errors resulting from the change of path set by the eclass.

	einfo "The test suite has 4 additional failures with package numba installed"
	einfo "Upstream have been informed via /blaze/issues/1117 @ github.com/"
	einfo "For optimum results, uninstall numba, but it counters protocol to exclude"
	einfo "dev-python/numba from dependencies in the ebuild"

	PYTHONPATH="${S}" py.test --ignore blaze/compute/tests/test_mongo_compute.py blaze \
		|| die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( blaze/examples/. )

	distutils-r1_python_install_all
}
