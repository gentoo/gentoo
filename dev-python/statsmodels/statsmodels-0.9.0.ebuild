# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1 eutils

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="https://www.statsmodels.org/stable/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.23.0[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jupyter_client[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		)
"

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "/sphinx.ext.intersphinx/d" -i docs/source/conf.py || die
	export VARTEXFONTS="${T}"/fonts
	export MPLCONFIGDIR="${T}"
	echo "backend : Agg" > "${MPLCONFIGDIR}"/matplotlibrc || die
	if use test; then
		# Errors reported upstream: https://github.com/statsmodels/statsmodels/issues/4850
		rm statsmodels/tsa/tests/test_tsa_indexes.py || die
		sed -i -e \
			"/def test_start_params_bug():/i@pytest.mark.xfail(reason='Known to fail on Gentoo')" \
			statsmodels/tsa/tests/test_arima.py || die
		sed -i -e \
			"s/def test_pandas_endog():/def _test_pandas_endog():/g" \
			statsmodels/tsa/statespace/tests/test_mlemodel.py || die
		sed -i -e \
			"/def test_all_datasets():/i@pytest.mark.xfail(reason='Known to fail on Gentoo')" \
			statsmodels/datasets/tests/test_data.py || die
		sed -i -e \
			"/def test_issue_339():/i@pytest.mark.xfail(reason='Known to fail on Gentoo')" \
			statsmodels/discrete/tests/test_discrete.py || die
		sed -i \
			-e "s/def test_hdr_multiple_alpha():/def _test_hdr_multiple_alpha():/g" \
			statsmodels/graphics/tests/test_functional.py || die
		sed -i \
			-e '1s/^/import pytest \n/' \
			-e "/def test_single_factor_repeated_measures_anova():/i@pytest.mark.xfail(reason='Known to fail on Gentoo with Python 3')" \
			-e "/def test_two_factors_repeated_measures_anova():/i@pytest.mark.xfail(reason='Known to fail on Gentoo with Python 3')" \
			-e "/def test_three_factors_repeated_measures_anova():/i@pytest.mark.xfail(reason='Known to fail on Gentoo with Python 3')" \
			-e "/def test_repeated_measures_aggregate_compare_with_ezANOVA():/i@pytest.mark.xfail(reason='Known to fail on Gentoo with Python 3')" \
			statsmodels/stats/tests/test_anova_rm.py || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx -b html --build-dir=docs/build
}

python_test() {
	cd "${BUILD_DIR}" || die
	py.test -v || die
}

python_install_all() {
	find . -name \*LICENSE.txt -delete || die
	use doc && HTML_DOCS=( docs/build/html/. )
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Plotting functionality" "dev-python/matplotlib"
}
