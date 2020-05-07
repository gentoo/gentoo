# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=manual
inherit distutils-r1

DESCRIPTION="C-style structs for Python"
HOMEPAGE="https://github.com/andreax79/python-cstruct https://pypi.org/project/cstruct/"
SRC_URI="https://github.com/andreax79/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# define setuptools dep manually to avoid warning
# setup.py contains entry_points, but it's an empty string
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.md )

distutils_enable_tests setup.py
