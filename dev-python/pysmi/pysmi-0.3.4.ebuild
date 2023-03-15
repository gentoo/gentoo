# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Python Lex & Yacc"
HOMEPAGE="https://github.com/etingof/pysmi"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"

RDEPEND="dev-python/ply[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/pysnmp[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest
distutils_enable_sphinx docs/source
