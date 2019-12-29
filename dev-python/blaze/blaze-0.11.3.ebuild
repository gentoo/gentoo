# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Next generation Python numpy"
HOMEPAGE="https://blaze.pydata.org https://blaze.readthedocs.io/en/latest/"
SRC_URI="https://github.com/blaze/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/bcolz[${PYTHON_USEDEP}]
	dev-python/cytoolz[${PYTHON_USEDEP}]
	dev-python/dask[${PYTHON_USEDEP}]
	dev-python/datashape[${PYTHON_USEDEP}]
	dev-python/dynd-python[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-cors[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/into[${PYTHON_USEDEP}]
	dev-python/multipledispatch[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numba[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/odo[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pytables[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/unicodecsv[${PYTHON_USEDEP}]
	dev-python/xlrd[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/contextlib2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd "${BUILD_DIR}"/lib
	# trying to skip a few tests which spill errors
	py.test \
		--ignore blaze/compute/tests/test_mongo_compute.py \
		--ignore blaze/compute/tests/test_core_compute.py \
		--ignore blaze/tests/test_interactive.py \
		blaze || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r blaze/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	rm -r "${ED}"usr/lib*/*/*/blaze/examples || die
}
