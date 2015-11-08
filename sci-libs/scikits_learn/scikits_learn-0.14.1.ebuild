# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1 eutils multilib flag-o-matic

MYPN="${PN/scikits_/scikit-}"
MYP="${MYPN}-${PV}"

DESCRIPTION="Python modules for machine learning and data mining"
HOMEPAGE="http://scikit-learn.org"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	dev-python/joblib[${PYTHON_USEDEP}]
	sci-libs/scikits[${PYTHON_USEDEP}]
	dev-python/numpy[lapack,${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[lapack,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}] )
	test? (
		dev-python/joblib[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

python_prepare_all() {
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared

	# scikits-learn now uses the horrible numpy.distutils automagic
	export SCIPY_FCONFIG="config_fc --noopt --noarch"

	# use system joblib
	rm -r sklearn/externals/joblib/* || die
	echo "from joblib import *" > sklearn/externals/joblib/__init__.py
	sed -i -e '/joblib\/test/d' sklearn/externals/setup.py || die
	sed -i -e 's/..externals.joblib/joblib/g' \
		sklearn/decomposition/tests/test_sparse_pca.py \
		sklearn/metrics/pairwise.py || die

	# use gentoo cblas infrastructure
	epatch "${FILESDIR}"/${P}-system-cblas.patch

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile ${SCIPY_FCONFIG}
}

python_compile_all() {
	if use doc; then
		cd "${S}/doc"
		local d="${BUILD_DIR}"/lib
		ln -s "${S}"/sklearn/datasets/{data,descr,images} \
			"${d}"/sklearn/datasets
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${d}" \
			emake html
		rm -r "${d}"/sklearn/datasets/{data,desr,images}
	fi
}

python_test() {
	# doc builds and runs tests
	use doc && return
	distutils_install_for_testing ${SCIPY_FCONFIG}
	esetup.py \
		install --root="${T}/test-${EPYTHON}" \
		--no-compile ${SCIPY_FCONFIG}
	pushd "${T}/test-${EPYTHON}/$(python_get_sitedir)" || die > /dev/null
	nosetests -v sklearn --exe || die
	popd > /dev/null
}

python_install() {
	distutils-r1_python_install ${SCIPY_FCONFIG}
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete
	use doc && HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
