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
KEYWORDS=""

RDEPEND="
	>=dev-python/annotated-types-0.4.0[${PYTHON_USEDEP}]
	~dev-python/pydantic-core-0.39.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/hatch-fancy-pypi-readme-22.5.0[${PYTHON_USEDEP}]
	test? (
		dev-python/dirty-equals[${PYTHON_USEDEP}]
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# expect -Werror
		tests/test_deprecated.py::test_extra_used_as_enum
	)
	local EPYTEST_IGNORE=(
		# require pytest-examples
		tests/test_docs.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock
}
