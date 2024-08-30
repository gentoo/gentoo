# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Mangling of various file formats that conveys binary information"
HOMEPAGE="
	https://pypi.org/project/bincopy/
	https://github.com/eerimoq/bincopy/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/argparse-addons-0.4.0[${PYTHON_USEDEP}]
	dev-python/humanfriendly[${PYTHON_USEDEP}]
	dev-python/pyelftools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
