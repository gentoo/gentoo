# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
CLI_COMPAT=( python3_{12..15} )
PYTHON_COMPAT=( "${CLI_COMPAT[@]}" python3_{14..15}t )
PYTHON_REQ_USE="threads(+),sqlite"

RUST_MIN_VER="1.91.0"
CRATES="
	cfg-if@1.0.4
	crunchy@0.2.4
	getrandom@0.3.4
	half@2.7.1
	heck@0.5.0
	libc@0.2.186
	once_cell@1.21.4
	portable-atomic@1.13.1
	ppv-lite86@0.2.21
	proc-macro2@1.0.106
	pyo3-build-config@0.29.0
	pyo3-ffi@0.29.0
	pyo3-macros-backend@0.29.0
	pyo3-macros@0.29.0
	pyo3@0.29.0
	quote@1.0.46
	r-efi@5.3.0
	rand@0.9.4
	rand_chacha@0.9.0
	rand_core@0.9.5
	syn@2.0.118
	target-lexicon@0.13.5
	unicode-ident@1.0.24
	wasip2@1.0.4+wasi-0.2.12
	wit-bindgen@0.57.1
	zerocopy-derive@0.8.53
	zerocopy@0.8.53
"

inherit cargo distutils-r1 optfeature

DESCRIPTION="A library for property based testing"
HOMEPAGE="
	https://github.com/HypothesisWorks/hypothesis/
	https://pypi.org/project/hypothesis/
"
SRC_URI="
	https://github.com/HypothesisWorks/hypothesis/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/${P}/hypothesis"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="cli"

RDEPEND="
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
	cli? (
		$(python_gen_cond_dep '
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
		' "${CLI_COMPAT[@]}")
	)
"
BDEPEND="
	test? (
		>=dev-python/attrs-22.2.0[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pytest-8[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	dev-python/hypothesis-gentoo[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-xdist )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

QA_PREBUILT="usr/lib/python.*/site-packages/hypothesis/_native.*"

python_test() {
	# NB: paths need to be relative to pytest.ini, i.e. start with hypothesis/
	local EPYTEST_DESELECT=(
		# broken somehow (xdist?)
		'hypothesis/tests/pytest/test_constant_collection_timing.py::test_constant_collection_timing[True]'
	)
	local EPYTEST_IGNORE=(
		# require syrupy
		tests/cover/test_custom_reprs.py
	)

	case ${EPYTHON} in
		python3.15*)
			EPYTEST_DESELECT+=(
				'hypothesis/tests/cover/test_lookup.py::test_resolves_forwardrefs_to_builtin_types[sentinel]'
				'hypothesis/tests/cover/test_lookup.py::test_resolves_builtin_types[sentinel]'
				'hypothesis/tests/cover/test_lambda_formatting.py::test_modifying_lambda_source_code_returns_unknown[False]'
			)
			;;
	esac

	local -x HYPOTHESIS_NO_PLUGINS=1
	epytest -o filterwarnings= tests/{cover,pytest,quality}
}

src_install() {
	local HAD_CLI=

	distutils-r1_src_install

	if [[ ! ${HAD_CLI} ]]; then
		rm -r "${ED}/usr/bin" || die
	fi
}

python_install() {
	distutils-r1_python_install
	if use cli && has "${EPYTHON}" "${CLI_COMPAT[@]/_/.}"; then
		HAD_CLI=1
	else
		rm -r "${D}$(python_get_scriptdir)" || die
	fi
}

pkg_postinst() {
	optfeature "datetime support" dev-python/pytz
	optfeature "dateutil support" dev-python/python-dateutil
	optfeature "numpy support" dev-python/numpy
	optfeature "django support" dev-python/django dev-python/pytz
	optfeature "pandas support" dev-python/pandas
	optfeature "pytest support" dev-python/pytest
}
