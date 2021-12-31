# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="black box tests Unix command line tools"
HOMEPAGE="https://liw.fi/cmdtest/"
SRC_URI="http://git.liw.fi/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86"

DEPEND="
	dev-python/cliapp[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/ttystatus[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

src_compile() {
	addwrite /proc/self/comm
	distutils-r1_src_compile
}

python_test() {
	"${EPYTHON}" -m unittest discover -v -p '*_tests.py' || die
}
