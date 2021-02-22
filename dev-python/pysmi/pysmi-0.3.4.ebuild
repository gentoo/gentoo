# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python Lex & Yacc"
HOMEPAGE="https://github.com/etingof/pysmi"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"

RDEPEND="dev-python/ply[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
