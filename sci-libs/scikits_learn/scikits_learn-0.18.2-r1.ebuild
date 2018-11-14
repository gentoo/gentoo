# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 flag-o-matic

MYPN="${PN/scikits_/scikit-}"
MYP="${MYPN}-${PV}"

DESCRIPTION="Python modules for machine learning and data mining"
HOMEPAGE="http://scikit-learn.org"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

# tried to unbundle virtual/python-funcsigs, funcsigs, odict
# but it is a large mess to maintain

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/numpy[lapack,${PYTHON_USEDEP}]
	sci-libs/scikits[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	virtual/blas:=
	virtual/cblas:=
"

DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[lapack,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	virtual/blas:=
	virtual/cblas:=
	doc? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MYP}"

PATCHES=( "${FILESDIR}/${PN}-0.18.1-system-cblas.patch" )

python_prepare_all() {
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared

	# scikits-learn now uses the horrible numpy.distutils automagic
	export SCIPY_FCONFIG="config_fc --noopt --noarch"

	# remove bundled cblas
	rm -r sklearn/src || die

	# commented out, since it is a mess to maintain
	# use system joblib
	#rm -r sklearn/externals/joblib || die
	#sed -i -e '/joblib/d' sklearn/externals/setup.py || die
	#for f in sklearn/{*/,}*.py; do
	#	sed -r -e '/^from/s/(sklearn|\.|)\.externals\.joblib/joblib/' \
	#		-e 's/from (sklearn|\.|)\.externals import/import/' -i $f || die
	#done

	# use system funcsigs and odict
	#rm sklearn/externals/funcsigs.py || die
	#rm sklearn/externals/odict.py || die
	#for f in sklearn/{utils/fixes.py,gaussian_process/{tests/test_,}kernels.py}; do
	#	sed -r -e 's/from (sklearn|\.|)\.externals\.funcsigs/from funcsigs/' -i $f || die
	#done
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile ${SCIPY_FCONFIG}
}

python_compile_all() {
	if use doc; then
		cd "${S}/doc" || die
		local d="${BUILD_DIR}/lib"
		ln -s \
		   "${S}"/sklearn/datasets/{data,descr,images} \
		   "${d}"/sklearn/datasets || die
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${d}" \
			emake html
		rm -r "${d}"/sklearn/datasets/{data,descr,images} || die
	fi
}

python_test() {
	# doc builds and runs tests
	use doc && return
	distutils_install_for_testing ${SCIPY_FCONFIG}
	esetup.py install \
			  --root="${T}/test-${EPYTHON}" \
			  --no-compile ${SCIPY_FCONFIG}
	pushd "${T}/test-${EPYTHON}/$(python_get_sitedir)" || die > /dev/null
	JOBLIB_MULTIPROCESSING=2 SKLEARN_SKIP_NETWORK_TESTS=1 nosetests -v sklearn --exe || die
	popd > /dev/null
}

python_install() {
	distutils-r1_python_install ${SCIPY_FCONFIG}
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete
	insinto /usr/share/doc/${PF}
	use doc && doins -r doc/_build/html
	use examples && doins -r examples
	distutils-r1_python_install_all
}
