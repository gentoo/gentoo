# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 optfeature

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="https://www.statsmodels.org/stable/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	>=dev-python/numpy-1.15[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.23.0[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.15[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.1[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/statsmodels-0.11.1-tests.patch"
)

distutils_enable_sphinx docs \
	'dev-python/ipykernel' \
	'dev-python/jupyter_client' \
	'dev-python/matplotlib' \
	'dev-python/nbconvert' \
	'dev-python/numpydoc'

distutils_enable_tests pytest

python_prepare_all() {
	# Prevent un-needed d'loading
	export VARTEXFONTS="${T}"/fonts
	export MPLCONFIGDIR="${T}"
	printf -- 'backend : Agg\n' > "${MPLCONFIGDIR}"/matplotlibrc || die

	# these tests require internet
	sed -i -e 's:test_results_on_the:_&:' \
		statsmodels/stats/tests/test_dist_dependant_measures.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x MKL_NUM_THREADS=1
	local -x OMP_NUM_THREADS=1
	local jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")

	pushd "${BUILD_DIR}" >/dev/null || die
	"${EPYTHON}" -c "
import statsmodels
statsmodels.test(extra_args=['-vv', '-n', '${jobs}'], exit=True)" \
		|| die "tests fail with ${EPYTHON}"
	popd >/dev/null || die
}

python_install_all() {
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Plotting functionality" "dev-python/matplotlib"
}
