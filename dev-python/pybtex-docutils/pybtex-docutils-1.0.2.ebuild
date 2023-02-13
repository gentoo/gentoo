# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A docutils backend for pybtex"
HOMEPAGE="https://github.com/mcmtroffaes/pybtex-docutils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/docutils-0.8[${PYTHON_USEDEP}]
	>=dev-python/pybtex-0.16[${PYTHON_USEDEP}]

"

distutils_enable_tests pytest
distutils_enable_sphinx doc
