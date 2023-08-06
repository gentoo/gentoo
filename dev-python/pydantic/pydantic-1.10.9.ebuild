# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

MY_P=${P/_beta/b}
DESCRIPTION="Data parsing and validation using Python type hints"
HOMEPAGE="
	https://github.com/pydantic/pydantic/
	https://pypi.org/project/pydantic/
"
SRC_URI="
	https://github.com/pydantic/pydantic/archive/v${PV/_beta/b}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="native-extensions"

RDEPEND="
	>=dev-python/typing-extensions-4.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	native-extensions? (
		<dev-python/cython-3[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/email-validator-1.2.1[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/CFLAGS/d' setup.py || die
	distutils-r1_src_prepare
}

python_compile() {
	if [[ ${EPYTHON} == pypy3 ]] || ! use native-extensions; then
		# do not build extensions on PyPy to workaround
		# https://github.com/cython/cython/issues/4763
		local -x SKIP_CYTHON=1
	fi
	distutils-r1_python_compile
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_mock

	local EPYTEST_DESELECT=(
		# flaky test, known upstream
		tests/test_hypothesis_plugin.py::test_can_construct_models_with_all_fields
		# mypy linting causes regressions with new mypy versions
		tests/mypy
	)
	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				tests/test_private_attributes.py::test_private_attribute
				tests/test_private_attributes.py::test_private_attribute_annotation
				tests/test_private_attributes.py::test_private_attribute_factory
				tests/test_private_attributes.py::test_private_attribute_multiple_inheritance
				tests/test_private_attributes.py::test_underscore_attrs_are_private
			)
			;;
		python3.12)
			EPYTEST_DESELECT+=(
				tests/test_abc.py::test_model_subclassing_abstract_base_classes_without_implementation_raises_exception
				tests/test_generics.py::test_partial_specification_name
				tests/test_generics.py::test_parse_generic_json
				tests/test_types.py::test_secretfield
			)
			;;
	esac
	rm -rf pydantic || die
	epytest
}
