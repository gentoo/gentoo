# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Math extension for Python-Markdown"
HOMEPAGE="
	https://github.com/mitya57/python-markdown-math/
	https://pypi.org/project/python-markdown-math/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-python/markdown-3.3.7[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
