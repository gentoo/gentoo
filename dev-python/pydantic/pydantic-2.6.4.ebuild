# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Data parsing and validation using Python type hints"
HOMEPAGE="
	https://github.com/pydantic/pydantic/
	https://pypi.org/project/pydantic/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/annotated-types-0.4.0[${PYTHON_USEDEP}]
	~dev-python/pydantic-core-2.16.3[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.1[${PYTHON_USEDEP}]
"
# pytest-8: https://github.com/pydantic/pydantic/issues/8674
BDEPEND="
	>=dev-python/hatch-fancy-pypi-readme-22.5.0[${PYTHON_USEDEP}]
	test? (
		dev-python/cloudpickle[${PYTHON_USEDEP}]
		dev-python/dirty-equals[${PYTHON_USEDEP}]
		>=dev-python/email-validator-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/Faker-18.13.0[${PYTHON_USEDEP}]
		<dev-python/pytest-8[${PYTHON_USEDEP}]
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

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock
}
