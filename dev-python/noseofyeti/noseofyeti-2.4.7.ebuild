# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A custom python codec that provides an RSpec style dsl for python"
HOMEPAGE="
	https://github.com/delfick/nose-of-yeti/
	https://pypi.org/project/noseOfYeti/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires alt-pytest-asyncio
	tests/test_using_pytest.py::TestPyTest::test_it_collects_tests_correctly
)
