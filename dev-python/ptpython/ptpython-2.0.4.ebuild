# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="Python REPL build on top of prompt_toolkit"
HOMEPAGE="https://pypi.org/project/ptpython/ https://github.com/prompt-toolkit/ptpython"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-2.0.6[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-2.1.0[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# Not included
RESTRICT=test

python_test() {
	"${PYTHON}" tests/run_tests.py || die
}
