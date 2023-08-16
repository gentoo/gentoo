# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Data parsing and validation using Python type hints"
HOMEPAGE="
	https://github.com/pydantic/pydantic/
	https://pypi.org/project/pydantic/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/annotated-types-0.4.0[${PYTHON_USEDEP}]
	~dev-python/pydantic-core-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/hatch-fancy-pypi-readme-22.5.0[${PYTHON_USEDEP}]
	test? (
		dev-python/dirty-equals[${PYTHON_USEDEP}]
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/Faker-18.13.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/benchmark/d' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=()
	local EPYTEST_IGNORE=(
		# require pytest-examples
		tests/test_docs.py
		# benchmarks
		tests/benchmarks
	)
	case ${EPYTHON} in
		python3.12)
			EPYTEST_DESELECT+=(
				tests/test_abc.py::test_model_subclassing_abstract_base_classes_without_implementation_raises_exception
				tests/test_computed_fields.py::test_abstractmethod_missing
				tests/test_edge_cases.py::test_abstractmethod_missing_for_all_decorators
				tests/test_generics.py::test_partial_specification_name
				tests/test_model_signature.py::test_annotated_field
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock
}
