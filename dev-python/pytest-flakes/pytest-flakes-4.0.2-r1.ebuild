# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Collection of small Python functions & classes"
HOMEPAGE="https://pypi.org/project/pytest-flakes/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyflakes[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
