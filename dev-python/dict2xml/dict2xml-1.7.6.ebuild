# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Small utility to convert a python dictionary into an XML string"
HOMEPAGE="
	https://github.com/delfick/python-dict2xml/
	https://pypi.org/project/dict2xml/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/noseofyeti[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
