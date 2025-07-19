# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
CLI_COMPAT=( python3_{11..13} )
PYTHON_COMPAT=( "${CLI_COMPAT[@]}" pypy3_11 python3_14 python3_{13,14}t )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 optfeature

TAG=hypothesis-python-${PV}
MY_P=hypothesis-${TAG}
DESCRIPTION="A library for property based testing"
HOMEPAGE="
	https://github.com/HypothesisWorks/hypothesis/
	https://pypi.org/project/hypothesis/
"
SRC_URI="
	https://github.com/HypothesisWorks/hypothesis/archive/${TAG}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}/hypothesis-python"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="cli"

RDEPEND="
	>=dev-python/attrs-22.2.0[${PYTHON_USEDEP}]
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
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pytest-8[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-rerunfailures )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	# NB: paths need to be relative to pytest.ini,
	# i.e. start with hypothesis-python/
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		python3.13t)
			EPYTEST_DESELECT+=(
				# TODO: missing warning
				'hypothesis-python/tests/cover/test_random_module.py::test_passing_referenced_instance_within_function_scope_warns'
			)
			;;
		python3.14*)
			EPYTEST_DESELECT+=(
				'hypothesis-python/tests/cover/test_compat.py::test_resolve_fwd_refs[Foo-Union]'
				'hypothesis-python/tests/cover/test_lookup.py::test_builds_suggests_from_type[Union]'
				hypothesis-python/tests/cover/test_attrs_inference.py::test_attrs_inference_builds
				hypothesis-python/tests/cover/test_lookup.py::test_bytestring_not_treated_as_generic_sequence
				hypothesis-python/tests/cover/test_lookup.py::test_issue_4194_regression
				hypothesis-python/tests/cover/test_lookup.py::test_resolves_forwardrefs_to_builtin_types
				hypothesis-python/tests/cover/test_lookup.py::test_specialised_collection_types
				hypothesis-python/tests/cover/test_lookup_py37.py::test_resolving_standard_collection_as_generic
				hypothesis-python/tests/cover/test_lookup_py37.py::test_resolving_standard_container_as_generic
				hypothesis-python/tests/cover/test_lookup_py37.py::test_resolving_standard_contextmanager_as_generic
				hypothesis-python/tests/cover/test_lookup_py37.py::test_resolving_standard_iterable_as_generic
				hypothesis-python/tests/cover/test_lookup_py37.py::test_resolving_standard_reversible_as_generic
				hypothesis-python/tests/cover/test_lookup_py37.py::test_resolving_standard_sequence_as_generic
				hypothesis-python/tests/cover/test_random_module.py::test_evil_prng_registration_nonsense
				hypothesis-python/tests/cover/test_random_module.py::test_passing_referenced_instance_within_function_scope_warns
				hypothesis-python/tests/cover/test_random_module.py::test_register_random_within_nested_function_scope
				hypothesis-python/tests/cover/test_random_module.py::test_registering_a_Random_is_idempotent
				hypothesis-python/tests/cover/test_type_lookup_forward_ref.py::test_bound_missing_dot_access_forward_ref
				hypothesis-python/tests/cover/test_type_lookup_forward_ref.py::test_bound_missing_forward_ref
				hypothesis-python/tests/cover/test_type_lookup_forward_ref.py::test_bound_type_checking_only_forward_ref_wrong_type
				hypothesis-python/tests/cover/test_type_lookup_forward_ref.py::test_bound_type_cheking_only_forward_ref
			)
			;;
	esac

	# subtests are broken by warnings from random plugins
	local -x PYTEST_PLUGINS=xdist.plugin,_hypothesis_pytestplugin
	local -x HYPOTHESIS_NO_PLUGINS=1

	epytest -o filterwarnings= --reruns=5 \
		tests/cover tests/pytest tests/quality
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
