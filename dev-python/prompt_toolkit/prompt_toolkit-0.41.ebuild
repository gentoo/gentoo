# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/prompt_toolkit/prompt_toolkit-0.41.ebuild,v 1.1 2015/06/22 09:51:39 jlec Exp $

EAPI=5

PYTHON_COMPAT=(python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Building powerful interactive command lines in Python"
HOMEPAGE="https://pypi.python.org/pypi/prompt_toolkit/ https://github.com/jonathanslenders/python-prompt-toolkit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/six-1.8.0[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# not contained in tarball
RESTRICT="test"

python_test() {
	"${PYTHON}" "${S}"/tests/run_tests.py || die
}
