# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A docutils backend for pybtex"
HOMEPAGE="https://github.com/mcmtroffaes/pybtex-docutils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pybtex[${PYTHON_USEDEP}]

"

distutils_enable_tests pytest
distutils_enable_sphinx doc
