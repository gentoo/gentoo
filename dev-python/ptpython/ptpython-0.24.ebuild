# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 eutils

DESCRIPTION="Python REPL build on top of prompt_toolkit"
HOMEPAGE="https://pypi.python.org/pypi/ptpython/ https://github.com/jonathanslenders/ptpython"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-python/prompt_toolkit-0.52[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.9.0[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

pkg_postinst() {
	optfeature "ipython enhanced version" dev-python/ipython
}
