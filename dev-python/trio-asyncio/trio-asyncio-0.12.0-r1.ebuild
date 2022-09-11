# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="a re-implementation of the asyncio mainloop on top of Trio"
HOMEPAGE="
	https://github.com/python-trio/trio-asyncio
	https://pypi.org/project/trio-asyncio/
"
SRC_URI="https://github.com/python-trio/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/outcome[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	>=dev-python/trio-0.15.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pytest-trio-0.6[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/no-pytest-runner.patch" )

EPYTEST_DESELECT=(
	# RuntimeError: You're within a Trio environment.
	# https://bugs.gentoo.org/834955
	/Python-3.8/test_asyncio/test_locks.py::ConditionTests::test_ambiguo
	/Python-3.9/test_asyncio/test_locks.py::ConditionTests::test_ambiguo
	/Python-3.10/test_asyncio/test_locks.py::ConditionTests::test_ambiguo
	/Python-3.11/test_asyncio/test_locks.py::ConditionTests::test_ambiguo
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinxcontrib-trio dev-python/sphinx_rtd_theme
