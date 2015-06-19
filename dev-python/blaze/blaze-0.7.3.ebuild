# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/blaze/blaze-0.7.3.ebuild,v 1.1 2015/03/17 07:02:36 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

# Tests attempt to import mystery modules in datashape
RESTRICT="test"

inherit distutils-r1

DESCRIPTION="Next generation Python numpy"
HOMEPAGE="http://blaze.pydata.org/"
SRC_URI="https://github.com/ContinuumIO/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# Currently doc build fails, reason now, attempt to import mystery modules in datashape
# Leaving doc build content in case this is fixed
IUSE="doc examples test"

# pyspark appears an optional dep not in portage. pyskit appears to be dropped
# pyparsing looks to be required still despite its absence from requirements.txt
PY2_USEDEP=$(python_gen_usedep python2_7)
RDEPEND="
	>=dev-python/blz-0.6.2[${PYTHON_USEDEP}]
	=dev-python/datashape-0.4*[${PYTHON_USEDEP}]
	>=dev-python/dynd-python-0.6.5[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/cytoolz[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/unicodecsv[${PY2_USEDEP}]
	>=dev-python/multipledispatch-0.4.7[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PY2_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/pytables[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/xlrd[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/into[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numba[${PYTHON_USEDEP}]
	dev-python/bcolz[${PYTHON_USEDEP}]
	"
DEPEND="
	>=dev-python/cython-0.18[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		dev-python/bokeh[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND}
		dev-python/pyyaml[${PYTHON_USEDEP}] )
	"
# Currently doc build fails, reason unclear but appears it's tied to use of
# redhat's anaconda installer, seemingly hostile to gentoo.

python_prepare_all() {
	# Prevent d'loading. Use this for now. Flagged for improved fix later.
	sed -e "s: 'sphinx.ext.intersphinx',::" -i docs/source/conf.py || die

	distutils-r1_python_prepare_all
}

#python_compile_all() {
#	use doc && emake -C docs html
#}

python_test() {
	# https://github.com/ContinuumIO/blaze/issues/791
	cd "${BUILD_DIR}"/lib || die
	"${PYTHON}" -c 'import blaze; blaze.test()' || die
}

python_install_all() {
#	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( blaze/examples/. )
	distutils-r1_python_install_all
}
