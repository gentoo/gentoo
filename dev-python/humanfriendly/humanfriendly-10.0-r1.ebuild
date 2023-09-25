# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..11} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Human friendly output for text interfaces using Python"
HOMEPAGE="https://pypi.org/project/humanfriendly/
	https://github.com/xolox/python-humanfriendly/
	https://humanfriendly.readthedocs.io/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

# This is completely broken
# AttributeError: module 'humanfriendly.tests' has no attribute 'connect'
RESTRICT="test"

BDEPEND="
	test? (
		dev-python/capturer[${PYTHON_USEDEP}]
		>=dev-python/coloredlogs-15.0.1[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_test() {
	epytest humanfriendly/tests.py
}
