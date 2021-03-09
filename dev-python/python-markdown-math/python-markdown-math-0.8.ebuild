# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Math extension for Python-Markdown"
HOMEPAGE="https://github.com/mitya57/python-markdown-math"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/markdown-3.0.1[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py
