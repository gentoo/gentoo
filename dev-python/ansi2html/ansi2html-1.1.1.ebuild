# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Convert text with ANSI color codes to HTML"
HOMEPAGE="https://pypi.python.org/pypi/ansi2html https://github.com/ralphbean/ansi2html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="test"

# They miserably fail.
RESTRICT="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.7.3[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
	)
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

python_test() {
	chmod -x "${S}"/tests/* || die
	esetup.py check
	esetup.py test
}

python_install_all() {
	doman man/"${PN}.1"
	DOCS=(  README.rst man/"${PN}".1.txt )
	distutils-r1_python_install_all
}
