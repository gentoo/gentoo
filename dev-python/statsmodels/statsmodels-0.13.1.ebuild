# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 multiprocessing optfeature

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="https://www.statsmodels.org/stable/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

DEPEND="
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.3[${PYTHON_USEDEP}]"
RDEPEND="
	${DEPEND}
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.25[${PYTHON_USEDEP}]
	>=dev-python/patsy-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.3[${PYTHON_USEDEP}]
"
BDEPEND="
	${DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

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

	sed -e 's:test_combine:_&:' \
		-i statsmodels/imputation/tests/test_mice.py || die
	sed -e 's:test_mixedlm:_&:' \
		-i statsmodels/stats/tests/test_mediation.py || die

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
