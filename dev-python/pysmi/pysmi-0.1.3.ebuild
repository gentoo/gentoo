# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="Python Lex & Yacc"
HOMEPAGE="https://github.com/etingof/pysmi"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"
IUSE=""

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
"
DEPEND=""
