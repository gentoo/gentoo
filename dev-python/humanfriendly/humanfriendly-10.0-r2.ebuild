# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Human friendly output for text interfaces using Python"
HOMEPAGE="https://pypi.org/project/humanfriendly/
	https://github.com/xolox/python-humanfriendly/
	https://humanfriendly.readthedocs.io/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/capturer[${PYTHON_USEDEP}]
		>=dev-python/coloredlogs-15.0.1[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-10.0-py3.13.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_test() {
	epytest humanfriendly/tests.py
}
