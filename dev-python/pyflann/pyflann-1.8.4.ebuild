# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for FLANN artificial neural network library"
HOMEPAGE="http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN/"
SRC_URI="http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-${PV}-src.zip
	test? ( https://dev.gentoo.org/~bicatali/distfiles/flann-${PV}-testdata.tar.xz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	~sci-libs/flann-${PV}"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/flann-${PV}-src/src/python"

python_prepare_all() {
	sed -e "s/@FLANN_VERSION@/${PV}/" \
		-e '/package_d/d' \
		-e "s/,.*'pyflann.lib'//" \
		setup.py.tpl >> setup.py

	use test && ln -s "${WORKDIR}"/testdata/* "${WORKDIR}"/flann-${PV}-src/test/
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${WORKDIR}"/flann-${PV}-src/test/
	local t
	#for t in test*.py; do
	# test_autotune buggy
	for t in test_{nn,nn_index,index_save,clustering}.py; do
		einfo "Running ${t}"
		PYTHONPATH="${BUILD_DIR}/lib" ${EPYTHON} ${t} || die
	done
}
