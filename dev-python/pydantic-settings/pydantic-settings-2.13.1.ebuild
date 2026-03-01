# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/pydantic/pydantic-settings
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Settings management using Pydantic"
HOMEPAGE="
	https://github.com/pydantic/pydantic-settings/
	https://pypi.org/project/pydantic-settings/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pydantic-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/typing-inspection-0.4.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO; can't repro in venv
	tests/test_precedence_and_merging.py::test_merging_preserves_earlier_values
)

EPYTEST_IGNORE=(
	# require pytest-examples
	tests/test_docs.py
)
